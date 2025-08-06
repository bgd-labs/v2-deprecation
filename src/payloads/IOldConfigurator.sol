// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
* The Address book version contains the mainnet interface.
* This reflects the polygon / avalanche version.
*/
interface IOldConfigurator {
  struct UpdateATokenInput {
      address asset;
      address treasury;
      address incentivesController;
      string name;
      string symbol;
      address implementation;
      bytes params;
    }

    function updateAToken(UpdateATokenInput calldata input) external;
}
