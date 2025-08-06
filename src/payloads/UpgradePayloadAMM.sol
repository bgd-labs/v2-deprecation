// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {AaveV2EthereumAMM, AaveV2EthereumAMMAssets} from "aave-address-book/AaveV2EthereumAMM.sol";

contract UpgradePayloadAMM {
  address public immutable COLLATERAL_MANAGER;
  address public immutable BTC_IMPL;

  constructor(address collateralManager, address btcImpl) {
    COLLATERAL_MANAGER = collateralManager;
    BTC_IMPL = btcImpl;
  }

  function execute() external {
    AaveV2EthereumAMM.POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager(COLLATERAL_MANAGER);
    AaveV2EthereumAMM.POOL_CONFIGURATOR.updateAToken(AaveV2EthereumAMMAssets.WBTC_UNDERLYING, BTC_IMPL);
  }
}
