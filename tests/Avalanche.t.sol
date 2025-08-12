// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';
import {DeployLib} from '../scripts/Deploy.s.sol';

import {DefaultTest} from './DefaultTest.t.sol';

contract AvalancheTest is DefaultTest('avalanche', '', 66912017) {
  constructor() {
    poolAddressesProvider = AaveV2Avalanche.POOL_ADDRESSES_PROVIDER;
    supplyAsset = AaveV2AvalancheAssets.USDCe_UNDERLYING;
    borrowAsset = AaveV2AvalancheAssets.USDTe_UNDERLYING;
  }

  function _deployPayload() internal override returns (address) {
    return DeployLib.deployAvalanche(vm);
  }
}
