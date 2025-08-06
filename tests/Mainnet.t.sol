// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ProtocolV2TestBase, ReserveConfig} from 'aave-helpers/src/ProtocolV2TestBase.sol';
import {AaveV2Ethereum} from "aave-address-book/AaveV2Ethereum.sol";
import {UpgradePayloadMainnet} from '../src/payloads/UpgradePayloadMainnet.sol';


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
    UpgradePayloadMainnet payload = new UpgradePayloadMainnet();
    defaultTest('core', AaveV2Ethereum.POOL, address(payload));
  }
}
