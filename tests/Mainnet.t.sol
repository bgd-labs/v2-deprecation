// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ProtocolV2TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV2TestBase.sol';
import {AaveV2Polygon} from "aave-address-book/AaveV2Polygon.sol";
import {AaveV2Avalanche} from "aave-address-book/AaveV2Avalanche.sol";
import {AaveV2Ethereum} from "aave-address-book/AaveV2Ethereum.sol";
import {AaveV2EthereumAMM} from "aave-address-book/AaveV2EthereumAMM.sol";
import {UpgradePayloadMainnet} from '../src/payloads/UpgradePayloadMainnet.sol';
import {DeployLib} from '../scripts/Deploy.s.sol';

contract DefaultTest is ProtocolV2TestBase {
  string public NETWORK;
    uint256 public immutable BLOCK_NUMBER;

  constructor(string memory network, uint256 blocknumber) {
      NETWORK = network;
      BLOCK_NUMBER = blocknumber;
    }

    function setUp() public virtual {
      vm.createSelectFork(vm.rpcUrl(NETWORK), BLOCK_NUMBER);
    }
}


contract MainnetTest is DefaultTest("mainnet", 23081690) {
  function test_default() external {
    address payload = DeployLib.deployMainnet(vm);
    defaultTest('core', AaveV2Ethereum.POOL, payload);
  }
}

contract AMMTest is DefaultTest("mainnet", 23081690) {
  function test_default() external {
    address payload = DeployLib.deployAMM(vm);
    defaultTest('amm', AaveV2EthereumAMM.POOL, payload);
  }
}

contract PolygonTest is DefaultTest("polygon", 74869895) {
  function test_default() external {
    address payload = DeployLib.deployPolygon(vm);
    defaultTest('polygon', AaveV2Polygon.POOL, payload);
  }
}

contract AvalancheTest is DefaultTest("avalanche", 66652691) {
  function test_default() external {
    address payload = DeployLib.deployAvalanche(vm);
    defaultTest('avalanche', AaveV2Avalanche.POOL, payload);
  }
}
