// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {DeployLib} from '../scripts/Deploy.s.sol';

import {DefaultTest} from './DefaultTest.t.sol';
import {Deployments} from '../src/Deployments.sol';

contract MainnetCoreTest is DefaultTest('mainnet', 'core', 23166833) {
  constructor() {
    poolAddressesProvider = AaveV2Ethereum.POOL_ADDRESSES_PROVIDER;
    supplyAsset = AaveV2EthereumAssets.DAI_UNDERLYING;
    borrowAsset = AaveV2EthereumAssets.USDC_UNDERLYING;
  }

  function _deployPayload() internal override returns (address) {
    return Deployments.CORE;
  }
}
