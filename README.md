# V2 Deprecation

V2 Pool have phased out over the recent years and months, with all reserves being borrowing disabled and supplying being limited to a handful reserves.

As a final step of deprecation, in line with the approach on v1, the close factor will be set to 100% allowing for a smooth cleanup of remaining debt positions without leaving dust in the system.
In addition, the clinic steward originally introduced for Aave V3, will be extended for V2, to allow cleanup of bad debt positions on behalf of the DAO.

## Specification

The proposal will execute the following two steps on each network:

1. call `POOL_ADDRESSES_PROVIDER.setLendingPoolCollateralManager` to replace the `LendingPoolCollateralManager` with a version that allows for a 100% close factor.
2. call `POOL_CONFIGURATOR.updateAToken(wBTC)` to upgrade the wBTC aToken implementation with a version that accounts for rounding imprecision.

In a different payload, the pool will grant the `Funds Manager` role to the `Clinic Steward V2`, which will allow the DAO to cleanup bad debt positions.
The Clinic Steward will be initialized with the following Budget for each network:

- V2 mainnet:
- V2 amm:
- V2 polygon:
- v2 avalanche:

## Testing

The proper functionality of the v2 pool post-upgrade, is tested via a [generalized test suite](./tests/DefaultTest.t.sol) and validated on each [network](./tests/).

## Diffs

The exact code diff for each individual network and contract can be found in the [diffs directory](./diffs).
