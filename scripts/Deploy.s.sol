// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {AaveV2EthereumAMM, AaveV2EthereumAMMAssets} from 'aave-address-book/AaveV2EthereumAMM.sol';
import {AaveV2Polygon, AaveV2PolygonAssets} from 'aave-address-book/AaveV2Polygon.sol';
import {AaveV2Avalanche, AaveV2AvalancheAssets} from 'aave-address-book/AaveV2Avalanche.sol';
import {Vm} from 'forge-std/Vm.sol';
import {Script, EthereumScript, PolygonScript, AvalancheScript} from 'solidity-utils/contracts/utils/ScriptUtils.sol';
import {IERC20Metadata} from 'openzeppelin-contracts/contracts/interfaces/IERC20Metadata.sol';
import {UpgradePayloadMainnet} from '../src/payloads/UpgradePayloadMainnet.sol';
import {UpgradePayloadAMM} from '../src/payloads/UpgradePayloadAMM.sol';
import {UpgradePayloadPolygon} from '../src/payloads/UpgradePayloadPolygon.sol';
import {UpgradePayloadAvalanche} from '../src/payloads/UpgradePayloadAvalanche.sol';

interface ICollateralManager {
  function LIQUIDATIONS_GRACE_SENTINEL() external view returns (address);
}

library DeployLib {
  function deployMainnetCore(Vm vm) internal returns (address) {
    address manager;
    {
      bytes memory args = abi.encode(
        ICollateralManager(AaveV2Ethereum.LENDING_POOL_COLLATERAL_MANAGER)
          .LIQUIDATIONS_GRACE_SENTINEL()
      );
      bytes memory managerBytecode = abi.encodePacked(
        vm.getCode(
          'src/core/LendingPoolCollateralManager/LendingPoolCollateralManager/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager'
        ),
        args
      );
      assembly {
        manager := create(0, add(managerBytecode, 0x20), mload(managerBytecode))
      }
    }
    address btcImpl;
    {
      bytes memory args = abi.encode(
        AaveV2Ethereum.POOL,
        AaveV2EthereumAssets.WBTC_UNDERLYING,
        AaveV2Ethereum.COLLECTOR,
        IERC20Metadata(AaveV2EthereumAssets.WBTC_A_TOKEN).name(),
        IERC20Metadata(AaveV2EthereumAssets.WBTC_A_TOKEN).symbol(),
        AaveV2Ethereum.DEFAULT_INCENTIVES_CONTROLLER
      );
      bytes memory btcImplBytecode = abi.encodePacked(
        vm.getCode(
          'src/core/AToken/AToken/@aave/protocol-v2/contracts/protocol/tokenization/AToken.sol:AToken'
        ),
        args
      );
      assembly {
        btcImpl := create(0, add(btcImplBytecode, 0x20), mload(btcImplBytecode))
      }
    }

    (bool success, ) = btcImpl.call(
      abi.encodeWithSignature(
        'initialize(uint8,string,string)',
        0, // underlyingAssetDecimals
        'ATOKEN_IMPL', // tokenName
        'ATOKEN_IMPL' // tokenSymbol
      )
    );
    require(success, 'Initialization failed');

    return address(new UpgradePayloadMainnet(manager, btcImpl));
  }

  function deployMainnetAMM(Vm vm) internal returns (address) {
    address manager;
    {
      bytes memory args = abi.encode(
        ICollateralManager(AaveV2EthereumAMM.LENDING_POOL_COLLATERAL_MANAGER)
          .LIQUIDATIONS_GRACE_SENTINEL()
      );
      bytes memory managerBytecode = abi.encodePacked(
        vm.getCode(
          'src/amm/LendingPoolCollateralManager/LendingPoolCollateralManager/src/v2EthLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager'
        ),
        args
      );
      assembly {
        manager := create(0, add(managerBytecode, 0x20), mload(managerBytecode))
      }
    }
    address btcImpl;
    {
      bytes memory args = abi.encode(
        IERC20Metadata(AaveV2EthereumAMMAssets.WBTC_A_TOKEN).name(),
        IERC20Metadata(AaveV2EthereumAMMAssets.WBTC_A_TOKEN).symbol(),
        IERC20Metadata(AaveV2EthereumAMMAssets.WBTC_A_TOKEN).decimals()
      );
      bytes memory btcImplBytecode = abi.encodePacked(
        vm.getCode('src/amm/AToken/AToken/contracts/protocol/tokenization/AToken.sol:AToken'),
        args
      );
      assembly {
        btcImpl := create(0, add(btcImplBytecode, 0x20), mload(btcImplBytecode))
      }
    }

    (bool success, ) = btcImpl.call(
      abi.encodeWithSignature(
        'initialize(address,address,address,address,uint8,string,string,bytes)',
        AaveV2EthereumAMM.POOL, // pool
        AaveV2EthereumAMM.COLLECTOR, // treasury
        address(0), // underlyingAsset
        address(0), // incentivesController
        0, // aTokenDecimals
        'ATOKEN_IMPL', // aTokenName
        'ATOKEN_IMPL', // aTokenSymbol
        '' // params
      )
    );
    require(success, 'Initialization failed');

    return address(new UpgradePayloadAMM(manager, btcImpl));
  }

  function deployPolygon(Vm vm) internal returns (address) {
    address manager;
    {
      bytes memory args = abi.encode(
        ICollateralManager(AaveV2Polygon.LENDING_POOL_COLLATERAL_MANAGER)
          .LIQUIDATIONS_GRACE_SENTINEL()
      );
      bytes memory managerBytecode = abi.encodePacked(
        vm.getCode(
          'src/polygon/LendingPoolCollateralManager/LendingPoolCollateralManager/src/v2PolLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager'
        ),
        args
      );
      assembly {
        manager := create(0, add(managerBytecode, 0x20), mload(managerBytecode))
      }
    }
    address btcImpl;
    {
      bytes memory args = abi.encode(
        IERC20Metadata(AaveV2PolygonAssets.WBTC_A_TOKEN).name(),
        IERC20Metadata(AaveV2PolygonAssets.WBTC_A_TOKEN).symbol(),
        IERC20Metadata(AaveV2PolygonAssets.WBTC_A_TOKEN).decimals()
      );
      bytes memory btcImplBytecode = abi.encodePacked(
        vm.getCode(
          'src/polygon/AToken/AToken/lib/protocol-v2/contracts/protocol/tokenization/AToken.sol:AToken'
        ),
        args
      );
      assembly {
        btcImpl := create(0, add(btcImplBytecode, 0x20), mload(btcImplBytecode))
      }
    }

    (bool success, ) = btcImpl.call(
      abi.encodeWithSignature(
        'initialize(address,address,address,address,uint8,string,string,bytes)',
        AaveV2Polygon.POOL, // pool
        AaveV2Polygon.COLLECTOR, // treasury
        address(0), // underlyingAsset
        AaveV2Polygon.DEFAULT_INCENTIVES_CONTROLLER, // incentivesController
        0, // aTokenDecimals
        'ATOKEN_IMPL', // aTokenName
        'ATOKEN_IMPL', // aTokenSymbol
        '' // params
      )
    );
    require(success, 'Initialization failed');

    return address(new UpgradePayloadPolygon(manager, btcImpl));
  }

  function deployAvalanche(Vm vm) internal returns (address) {
    address manager;
    {
      bytes memory args = abi.encode(
        ICollateralManager(AaveV2Avalanche.LENDING_POOL_COLLATERAL_MANAGER)
          .LIQUIDATIONS_GRACE_SENTINEL()
      );
      bytes memory managerBytecode = abi.encodePacked(
        vm.getCode(
          'src/avalanche/LendingPoolCollateralManager/LendingPoolCollateralManager/src/v2AvaLendingPoolCollateralManager/LendingPoolCollateralManager/contracts/protocol/lendingpool/LendingPoolCollateralManager.sol:LendingPoolCollateralManager'
        ),
        args
      );
      assembly {
        manager := create(0, add(managerBytecode, 0x20), mload(managerBytecode))
      }
    }
    address btcImpl;
    {
      bytes memory args = abi.encode(
        IERC20Metadata(AaveV2AvalancheAssets.WBTCe_A_TOKEN).name(),
        IERC20Metadata(AaveV2AvalancheAssets.WBTCe_A_TOKEN).symbol(),
        IERC20Metadata(AaveV2AvalancheAssets.WBTCe_A_TOKEN).decimals()
      );
      bytes memory btcImplBytecode = abi.encodePacked(
        vm.getCode(
          'src/avalanche/AToken/AToken/lib/protocol-v2/contracts/protocol/tokenization/AToken.sol:AToken'
        ),
        args
      );
      assembly {
        btcImpl := create(0, add(btcImplBytecode, 0x20), mload(btcImplBytecode))
      }
    }

    (bool success, ) = btcImpl.call(
      abi.encodeWithSignature(
        'initialize(address,address,address,address,uint8,string,string,bytes)',
        AaveV2Avalanche.POOL, // pool
        AaveV2Avalanche.COLLECTOR, // treasury
        address(0), // underlyingAsset
        AaveV2Avalanche.DEFAULT_INCENTIVES_CONTROLLER, // incentivesController
        0, // aTokenDecimals
        'ATOKEN_IMPL', // aTokenName
        'ATOKEN_IMPL', // aTokenSymbol
        '' // params
      )
    );
    require(success, 'Initialization failed');

    return address(new UpgradePayloadAvalanche(manager, btcImpl));
  }
}

contract DeployMainnet is EthereumScript {
  function run() external broadcast {
    DeployLib.deployMainnetCore(vm);
  }
}

contract DeployMainnetAmm is EthereumScript {
  function run() external broadcast {
    DeployLib.deployMainnetAMM(vm);
  }
}

contract DeployPolygon is PolygonScript {
  function run() external broadcast {
    DeployLib.deployPolygon(vm);
  }
}

contract DeployAvalanche is AvalancheScript {
  function run() external broadcast {
    DeployLib.deployAvalanche(vm);
  }
}
