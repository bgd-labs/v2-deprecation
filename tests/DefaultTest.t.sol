// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC20Metadata} from 'openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol';
import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';

import {ProtocolV2TestBase, ILendingPool, ILendingPoolConfigurator, IAaveOracle, ILendingPoolAddressesProvider} from 'aave-helpers/src/ProtocolV2TestBase.sol';

abstract contract DefaultTest is ProtocolV2TestBase {
  using SafeERC20 for IERC20;

  string public NETWORK;
  string public NETWORK_SUB_NAME;

  uint256 public immutable BLOCK_NUMBER;

  ILendingPoolAddressesProvider public poolAddressesProvider;
  ILendingPoolConfigurator public poolConfigurator;
  ILendingPool public pool;
  IAaveOracle public oracle;

  address public supplyAsset;
  address public borrowAsset;

  address public immutable alice = address(0x1000);

  constructor(string memory network, string memory networkSubName, uint256 blocknumber) {
    NETWORK = network;
    NETWORK_SUB_NAME = networkSubName;

    BLOCK_NUMBER = blocknumber;
  }

  function setUp() public virtual {
    vm.createSelectFork(vm.rpcUrl(NETWORK), BLOCK_NUMBER);

    poolConfigurator = ILendingPoolConfigurator(poolAddressesProvider.getLendingPoolConfigurator());
    pool = ILendingPool(poolAddressesProvider.getLendingPool());
    oracle = IAaveOracle(poolAddressesProvider.getPriceOracle());
  }

  function test_default() external {
    address payload = _deployPayload();
    defaultTest(string.concat(NETWORK, NETWORK_SUB_NAME), pool, payload);
  }

  function test_close_factor() external {
    address payload = _deployPayload();

    executePayload(vm, payload);

    uint256 supplyAmount = _getTokenAmountByDollarValue({
      underlyingAsset: supplyAsset,
      dollarValue: 10_000
    });
    deal(supplyAsset, alice, supplyAmount);

    uint256 borrowAmount = _getTokenAmountByDollarValue({
      underlyingAsset: borrowAsset,
      dollarValue: 7_000
    });

    _enableSupplyReserve(supplyAsset);
    _enableBorrowReserve(borrowAsset);

    vm.startPrank(alice);

    IERC20(supplyAsset).forceApprove(address(pool), supplyAmount);
    pool.deposit({asset: supplyAsset, amount: supplyAmount, onBehalfOf: alice, referralCode: 0});

    pool.borrow({
      asset: borrowAsset,
      amount: borrowAmount,
      interestRateMode: 2,
      referralCode: 0,
      onBehalfOf: alice
    });

    vm.stopPrank();

    _disableSupplyReserve(supplyAsset);

    uint256 finalDebtAmount = IERC20(pool.getReserveData(borrowAsset).variableDebtTokenAddress)
      .balanceOf(alice);

    deal(borrowAsset, address(this), finalDebtAmount * 2);
    IERC20(borrowAsset).forceApprove(address(pool), finalDebtAmount * 2);

    pool.liquidationCall({
      collateralAsset: supplyAsset,
      debtAsset: borrowAsset,
      user: alice,
      debtToCover: type(uint256).max,
      receiveAToken: false
    });

    uint256 liquidatedAmount = finalDebtAmount * 2 - IERC20(borrowAsset).balanceOf(address(this));

    assertApproxEqRel(
      liquidatedAmount,
      finalDebtAmount,
      0.00000001e18 // 0.000001% tolerance
    );
  }

  function _deployPayload() internal virtual returns (address);

  function _enableSupplyReserve(address asset) internal {
    address poolAdmin = poolAddressesProvider.getPoolAdmin();

    vm.startPrank(poolAdmin);

    poolConfigurator.unfreezeReserve(asset);

    poolConfigurator.configureReserveAsCollateral({
      asset: asset,
      ltv: 75_00,
      liquidationThreshold: 80_00,
      liquidationBonus: 105_00
    });

    vm.stopPrank();
  }

  function _enableBorrowReserve(address asset) internal {
    address poolAdmin = poolAddressesProvider.getPoolAdmin();

    vm.startPrank(poolAdmin);

    poolConfigurator.unfreezeReserve(asset);
    poolConfigurator.enableBorrowingOnReserve(asset, true);

    vm.stopPrank();
  }

  function _disableSupplyReserve(address asset) internal {
    address poolAdmin = poolAddressesProvider.getPoolAdmin();

    vm.startPrank(poolAdmin);

    poolConfigurator.configureReserveAsCollateral({
      asset: asset,
      ltv: 0,
      liquidationThreshold: 60_00,
      liquidationBonus: 105_00
    });

    vm.stopPrank();
  }

  function _getTokenAmountByDollarValue(
    address underlyingAsset,
    uint256 dollarValue
  ) private view returns (uint256) {
    uint256 latestAnswer = oracle.getAssetPrice(underlyingAsset);
    return (dollarValue * 10 ** (8 + IERC20Metadata(underlyingAsset).decimals())) / latestAnswer;
  }
}
