// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';
import {DeployLib} from '../scripts/Deploy.s.sol';

import {DefaultTest} from './DefaultTest.t.sol';
import {Deployments} from '../src/Deployments.sol';

contract AvalancheTest is DefaultTest('avalanche', '', 67249404) {
  constructor() {
    poolAddressesProvider = AaveV2Avalanche.POOL_ADDRESSES_PROVIDER;
    supplyAsset = AaveV2AvalancheAssets.USDCe_UNDERLYING;
    borrowAsset = AaveV2AvalancheAssets.USDTe_UNDERLYING;
  }

  function _deployPayload() internal override returns (address) {
    return Deployments.AVALANCHE;
  }
}
