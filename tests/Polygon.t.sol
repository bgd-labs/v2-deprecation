// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2Polygon, AaveV2PolygonAssets} from 'aave-address-book/AaveV2Polygon.sol';
import {DeployLib} from '../scripts/Deploy.s.sol';

import {DefaultTest} from './DefaultTest.t.sol';
import {Deployments} from '../src/Deployments.sol';

contract PolygonTest is DefaultTest('polygon', '', 75350631) {
  constructor() {
    poolAddressesProvider = AaveV2Polygon.POOL_ADDRESSES_PROVIDER;
    supplyAsset = AaveV2PolygonAssets.USDT_UNDERLYING;
    borrowAsset = AaveV2PolygonAssets.USDC_UNDERLYING;
  }

  function _deployPayload() internal override returns (address) {
    return Deployments.POLYGON;
  }
}
