// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {AaveV2Polygon, AaveV2PolygonAssets} from "aave-address-book/AaveV2Polygon.sol";
import {IERC20Metadata} from "openzeppelin-contracts/contracts/interfaces/IERC20Metadata.sol";
import {IOldConfigurator} from './IOldConfigurator.sol';

contract UpgradePayloadPolygon {
  address public immutable COLLATERAL_MANAGER;
  address public immutable BTC_IMPL;

  constructor(address collateralManager, address btcImpl) {
    COLLATERAL_MANAGER = collateralManager;
    BTC_IMPL = btcImpl;
  }

  function execute() external {
    AaveV2Polygon.POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager(COLLATERAL_MANAGER);
    IOldConfigurator.UpdateATokenInput memory input = IOldConfigurator.UpdateATokenInput({
      asset: AaveV2PolygonAssets.WBTC_UNDERLYING,
      treasury: address(AaveV2Polygon.COLLECTOR),
      incentivesController: AaveV2Polygon.DEFAULT_INCENTIVES_CONTROLLER,
      name: IERC20Metadata(AaveV2PolygonAssets.WBTC_A_TOKEN).name(),
      symbol: IERC20Metadata(AaveV2PolygonAssets.WBTC_A_TOKEN).symbol(),
      implementation: BTC_IMPL,
      params:''
    });
    IOldConfigurator(address(AaveV2Polygon.POOL_CONFIGURATOR)).updateAToken(
      input
    );
  }
}
