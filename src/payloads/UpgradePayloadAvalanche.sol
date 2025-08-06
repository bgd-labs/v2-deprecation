// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {AaveV2Avalanche, AaveV2AvalancheAssets} from "aave-address-book/AaveV2Avalanche.sol";
import {IERC20Metadata} from "openzeppelin-contracts/contracts/interfaces/IERC20Metadata.sol";
import {IOldConfigurator} from './IOldConfigurator.sol';

contract UpgradePayloadAvalanche {
  address public immutable COLLATERAL_MANAGER;
  address public immutable BTC_IMPL;

  constructor(address collateralManager, address btcImpl) {
    COLLATERAL_MANAGER = collateralManager;
    BTC_IMPL = btcImpl;
  }

  function execute() external {
    AaveV2Avalanche.POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager(COLLATERAL_MANAGER);
    IOldConfigurator.UpdateATokenInput memory input = IOldConfigurator.UpdateATokenInput({
      asset: AaveV2AvalancheAssets.WBTCe_UNDERLYING,
      treasury: address(AaveV2Avalanche.COLLECTOR),
      incentivesController: AaveV2Avalanche.DEFAULT_INCENTIVES_CONTROLLER,
      name: IERC20Metadata(AaveV2AvalancheAssets.WBTCe_A_TOKEN).name(),
      symbol: IERC20Metadata(AaveV2AvalancheAssets.WBTCe_A_TOKEN).symbol(),
      implementation: BTC_IMPL,
      params:''
    });
    IOldConfigurator(address(AaveV2Avalanche.POOL_CONFIGURATOR)).updateAToken(
      input
    );
  }
}
