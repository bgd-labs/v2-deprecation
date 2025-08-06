import child_process, {execSync} from 'child_process';
import {
  AaveV2Ethereum,
  AaveV2Avalanche,
  AaveV2EthereumAMM,
  AaveV2Polygon,
} from '@bgd-labs/aave-address-book';

function runCmd(cmd: string) {
  var resp = child_process.execSync(cmd);
  var result = resp.toString();
  return result;
}

function downloadPool(
  name: string,
  {
    CHAIN_ID,
    LENDING_POOL_COLLATERAL_MANAGER,
  }: {CHAIN_ID: number; LENDING_POOL_COLLATERAL_MANAGER: string}
) {}

// downloadPool('core', AaveV2Ethereum);
// downloadPool('amm', AaveV2EthereumAMM);
// downloadPool('avalanche', AaveV2Avalanche);
// downloadPool('polygon', AaveV2Polygon);

const pools = {
  core: AaveV2Ethereum,
  amm: AaveV2EthereumAMM,
  avalanche: AaveV2Avalanche,
  polygon: AaveV2Polygon,
} as const;

const contracts = {
  LendingPoolCollateralManager: 'LENDING_POOL_COLLATERAL_MANAGER',
  Pool: 'POOL_IMPL',
} as const;

function diffPools() {
  const contractKeys = Object.keys(contracts) as (keyof typeof contracts)[];
  for (let j = 0; j < contractKeys.length; j++) {
    const poolKeys = Object.keys(pools) as (keyof typeof pools)[];
    for (let i = 1; i < poolKeys.length; i++) {
      // execSync(
      //   `npx @bgd-labs/cli@0.0.47 codeDiff \
      //   --address1 ${pools[poolKeys[0]][contracts[contractKeys[j]]]} --chainId1 ${
      //     pools[poolKeys[0]].CHAIN_ID
      //   } \
      //   --address2 ${pools[poolKeys[i]][contracts[contractKeys[j]]]} --chainId2 ${
      //     pools[poolKeys[i]].CHAIN_ID
      //   } -o file`
      // );
      runCmd(
        `cast source --chain-id ${pools[poolKeys[i]].CHAIN_ID} -d src/${
          pools[poolKeys[i]].CHAIN_ID
        }/${contractKeys[j]} ${pools[poolKeys[i]][contracts[contractKeys[j]]]}`
      );
    }
  }
}

diffPools();
