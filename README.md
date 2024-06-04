## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy
1. Deploy implementation
```shell
$ forge script script/PunkgaReward_deployImpl.s.sol --rpc-url aura --private-key $PRIVATE_KEY --broadcast
```

2. Deploy proxy
```shell
$ forge script script/PunkgaReward_deployProxy.s.sol --rpc-url aura --private-key $PRIVATE_KEY --broadcast 
```

### Verify
```shell
$ forge verify-contract --verifier sourcify --verifier-url https://indexer-v2.dev.aurascan.io/sourcify/ --rpc-url https://jsonrpc.serenity.aura.network/  <contract_address>  src/PunkgaReward.sol:PunkgaReward
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
