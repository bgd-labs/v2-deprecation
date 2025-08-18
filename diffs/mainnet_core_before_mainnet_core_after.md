## Reserve changes

### Reserves altered

#### WBTC ([0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599](https://etherscan.io/address/0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599))

| description | value before | value after |
| --- | --- | --- |
| aTokenImpl | [0xC2fcab14Ec1F2dFA82a23C639c4770345085a50F](https://etherscan.io/address/0xC2fcab14Ec1F2dFA82a23C639c4770345085a50F) | [0xA33eCc2125f6FD0b900945b149176D46f0474Ac4](https://etherscan.io/address/0xA33eCc2125f6FD0b900945b149176D46f0474Ac4) |
| aTokenName | Aave interest bearing WBTC | ATOKEN_IMPL |
| aTokenSymbol | aWBTC | ATOKEN_IMPL |


## Raw diff

```json
{
  "poolConfig": {
    "lendingPoolCollateralManager": {
      "from": "0x368e6441bB27159c6e8e6d3bbd9147BEcBA915E3",
      "to": "0xcc9632725266473ab5d42320E8Ae00437A1df3bB"
    }
  },
  "reserves": {
    "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599": {
      "aTokenImpl": {
        "from": "0xC2fcab14Ec1F2dFA82a23C639c4770345085a50F",
        "to": "0xA33eCc2125f6FD0b900945b149176D46f0474Ac4"
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