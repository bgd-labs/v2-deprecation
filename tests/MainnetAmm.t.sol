// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2EthereumAMM, AaveV2EthereumAMMAssets} from 'aave-address-book/AaveV2EthereumAMM.sol';
import {DeployLib} from '../scripts/Deploy.s.sol';

import {DefaultTest} from './DefaultTest.t.sol';

contract MainnetAmmTest is DefaultTest('mainnet', 'amm', 23118249) {
  constructor() {
    poolAddressesProvider = AaveV2EthereumAMM.POOL_ADDRESSES_PROVIDER;
    supplyAsset = AaveV2EthereumAMMAssets.USDT_UNDERLYING;
    borrowAsset = AaveV2EthereumAMMAssets.USDC_UNDERLYING;
  }

  function _deployPayload() internal override returns (address) {
    return DeployLib.deployMainnetAMM(vm);
  }
}
