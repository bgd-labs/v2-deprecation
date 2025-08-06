// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {AaveV2Ethereum, AaveV2EthereumAssets} from "aave-address-book/AaveV2Ethereum.sol";

contract UpgradePayloadMainnet {
  address public immutable COLLATERAL_MANAGER;
  address public immutable BTC_IMPL;

  constructor(address collateralManager, address btcImpl) {
    COLLATERAL_MANAGER = collateralManager;
    BTC_IMPL = btcImpl;
  }

  function execute() external {
    AaveV2Ethereum.POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager(COLLATERAL_MANAGER);
    AaveV2Ethereum.POOL_CONFIGURATOR.updateAToken(AaveV2EthereumAssets.WBTC_UNDERLYING, BTC_IMPL);
  }
}
