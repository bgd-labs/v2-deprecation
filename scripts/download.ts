import child_process from 'child_process';
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
) {
  runCmd(
    `cast source --chain-id ${CHAIN_ID} -d src/${name}/LendingPoolCollateralManager ${LENDING_POOL_COLLATERAL_MANAGER}`
  );
}

downloadPool('core', AaveV2Ethereum);
downloadPool('amm', AaveV2EthereumAMM);
downloadPool('avalanche', AaveV2Avalanche);
downloadPool('polygon', AaveV2Polygon);
