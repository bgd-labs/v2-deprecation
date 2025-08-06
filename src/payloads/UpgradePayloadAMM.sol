// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {AaveV2EthereumAMM, AaveV2EthereumAMMAssets} from "aave-address-book/AaveV2EthereumAMM.sol";
import {IERC20Metadata} from "openzeppelin-contracts/contracts/interfaces/IERC20Metadata.sol";
import {IOldConfigurator} from './IOldConfigurator.sol';

contract UpgradePayloadAMM {
  address public immutable COLLATERAL_MANAGER;
  address public immutable BTC_IMPL;

  constructor(address collateralManager, address btcImpl) {
    COLLATERAL_MANAGER = collateralManager;
    BTC_IMPL = btcImpl;
  }

  function execute() external {
    AaveV2EthereumAMM.POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager(COLLATERAL_MANAGER);
    IOldConfigurator.UpdateATokenInput memory input = IOldConfigurator.UpdateATokenInput({
      asset: AaveV2EthereumAMMAssets.WBTC_UNDERLYING,
      treasury: address(AaveV2EthereumAMM.COLLECTOR),
      incentivesController: address(0),
      name: IERC20Metadata(AaveV2EthereumAMMAssets.WBTC_A_TOKEN).name(),
      symbol: IERC20Metadata(AaveV2EthereumAMMAssets.WBTC_A_TOKEN).symbol(),
      implementation: BTC_IMPL,
      params:''
    });
    IOldConfigurator(address(AaveV2EthereumAMM.POOL_CONFIGURATOR)).updateAToken(
      input
    );
  }
}
