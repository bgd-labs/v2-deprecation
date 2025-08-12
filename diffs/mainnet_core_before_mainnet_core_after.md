## Reserve changes

### Reserves altered

#### WBTC ([0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599](https://etherscan.io/address/0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599))

| description | value before | value after |
| --- | --- | --- |
| aTokenImpl | [0xC2fcab14Ec1F2dFA82a23C639c4770345085a50F](https://etherscan.io/address/0xC2fcab14Ec1F2dFA82a23C639c4770345085a50F) | [0x2e234DAe75C793f67A35089C9d99245E1C58470b](https://etherscan.io/address/0x2e234DAe75C793f67A35089C9d99245E1C58470b) |
| aTokenName | Aave interest bearing WBTC | ATOKEN_IMPL |
| aTokenSymbol | aWBTC | ATOKEN_IMPL |


## Raw diff

```json
{
  "poolConfig": {
    "lendingPoolCollateralManager": {
      "from": "0x368e6441bB27159c6e8e6d3bbd9147BEcBA915E3",
      "to": "0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f"
    }
  },
  "reserves": {
    "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599": {
      "aTokenImpl": {
        "from": "0xC2fcab14Ec1F2dFA82a23C639c4770345085a50F",
        "to": "0x2e234DAe75C793f67A35089C9d99245E1C58470b"
      },
      "aTokenName": {
        "from": "Aave interest bearing WBTC",
        "to": "ATOKEN_IMPL"
      },
      "aTokenSymbol": {
        "from": "aWBTC",
        "to": "ATOKEN_IMPL"
      }
    }
  }
}
```