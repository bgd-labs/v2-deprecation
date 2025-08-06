// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {AaveV2Ethereum} from "aave-address-book/AaveV2Ethereum.sol";

contract UpgradePayloadMainnet {
  address public immutable COLLATERAL_MANAGER;

  constructor(address collateralManager) {
    COLLATERAL_MANAGER = collateralManager;
  }

  function execute() external {
    AaveV2Ethereum.POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager(COLLATERAL_MANAGER);
  }
}
