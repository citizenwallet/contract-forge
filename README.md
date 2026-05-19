## Citizen Wallet Smart Contracts

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

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>

$ forge script script/anvil/CardManagerAnvil.s.sol:CardManagerAnvilScript --sig "deploy()"  --rpc-url http://127.0.0.1:8545

$ forge script script/anvil/SafeSingleton.s.sol:SafeSingletonScript --sig "deploy()"  --rpc-url http://127.0.0.1:8545

$ forge script script/anvil/SessionManagerModuleAnvil.s.sol:SessionManagerModuleAnvilScript --sig "deploy()"  --rpc-url http://127.0.0.1:8545
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

# Create2

```shell
forge create --rpc-url $BERACHAIN_MAINNET_RPC_URL --private-key $PRIVATE_KEY src/Create2/Create2.sol:Create2
```

Add `--broadcast` to the end of the following the actually publish.

# Token
```shell
$ forge script script/UpgradeableCommunityToken.s.sol:UpgradeableCommunityTokenScript --sig "deploy(address[], string, string)" "[0x0a209fd139815498597076Fe91B5F0c727E304C6]" "Uccle Europe Basketball" "UEB" --rpc-url $GNOSIS_MAINNET_RPC_URL --verify --verifier etherscan --etherscan-api-key $ETHEREUM_MAINNET_ETHERSCAN_API_KEY --private-key $PRIVATE_KEY
```

# Community Module
```shell
$ forge script script/CommunityModule.s.sol:CommunityModuleScript --sig "deploy()" --rpc-url $BERACHAIN_MAINNET_RPC_URL --verify --verifier etherscan --etherscan-api-key $ETHEREUM_MAINNET_ETHERSCAN_API_KEY --private-key $PRIVATE_KEY 
```

# Community Module Upgrade (v2)
```shell
$ forge script script/upgrade/UpgradeCommunityModule.s.sol:UpgradeCommunityModuleScript --sig "run(address)" "0x7079253c0358eF9Fd87E16488299Ef6e06F403B6" --rpc-url $POLYGON_ZK_MAINNET_RPC_URL --etherscan-api-key $POLYGON_ZK_MAINNET_ETHERSCAN_API_KEY --verify --verifier-url $POLYGON_ZK_ETHERSCAN_VERIFIER_URL --private-key $PRIVATE_KEY 
```

# Community + Paymaster Module
```shell
$ forge script script/CommunityAndPaymaster.s.sol:CommunityAndPaymasterModuleScript --sig "deploy(address[])" "[]" --rpc-url $GNOSIS_MAINNET_RPC_URL --etherscan-api-key $GNOSIS_MAINNET_ETHERSCAN_API_KEY --verify --verifier-url $GNOSIS_ETHERSCAN_VERIFIER_URL --private-key $PRIVATE_KEY 
```

# Paymaster
```shell
$ forge script script/Paymaster.s.sol:PaymasterDeploy --sig "deploy(address,address,address[])" 0x49a44Fb70522f4084F4a7ACAb5FFb40A3d14B427  0x49a44Fb70522f4084F4a7ACAb5FFb40A3d14B427 "[0x6f1e3eDB0c7885E899b47EbDD2F0427432705eb3,0x73A6aa265E999E74bC1EDB14f3c330aD3f029761,0xBA861e2DABd8316cf11Ae7CdA101d110CF581f28,0xE2F3DC3E638113b9496060349e5332963d9C1152]" --rpc-url $GNOSIS_MAINNET_RPC_URL --verify --verifier etherscan --etherscan-api-key $ETHEREUM_MAINNET_ETHERSCAN_API_KEY --private-key $PRIVATE_KEY --broadcast
```

# Paymaster (no whitelist — backend enforces target allowlisting)
```shell
$ forge script script/PaymasterNoWhitelist.s.sol:PaymasterNoWhitelistDeploy --sig "deploy(address,address)" 0xd87172d9335B0082A41DD9c60168393Bdd72443d 0xd87172d9335B0082A41DD9c60168393Bdd72443d --rpc-url $BASE_MAINNET_RPC_URL --verify --verifier etherscan --etherscan-api-key $ETHEREUM_MAINNET_ETHERSCAN_API_KEY --private-key $PRIVATE_KEY --broadcast
```

# Account Factory
```shell
$ forge script script/AccountFactory.s.sol:AccountFactoryScript --sig "deploy(address)" 0x7079253c0358eF9Fd87E16488299Ef6e06F403B6 --rpc-url $BERACHAIN_MAINNET_RPC_URL --verify --verifier etherscan --etherscan-api-key $ETHEREUM_MAINNET_ETHERSCAN_API_KEY --private-key $PRIVATE_KEY 
```

# Card Manager
```shell
$ forge script script/CardManagerModule.s.sol:CardManagerModuleScript --sig "deploy(address)" 0x7079253c0358eF9Fd87E16488299Ef6e06F403B6 --rpc-url $BERACHAIN_MAINNET_RPC_URL --verify --verifier etherscan --etherscan-api-key $ETHEREUM_MAINNET_ETHERSCAN_API_KEY --private-key $PRIVATE_KEY 
```

# Session Manager
```shell
$ forge script script/SessionManagerModule.s.sol:SessionManagerModuleScript --sig "deploy(address)" 0x7079253c0358eF9Fd87E16488299Ef6e06F403B6 --rpc-url $BERACHAIN_MAINNET_RPC_URL --verify --verifier etherscan --etherscan-api-key $ETHEREUM_MAINNET_ETHERSCAN_API_KEY --private-key $PRIVATE_KEY
```

# Session Module Upgrade (v2)
```shell
$ forge script script/upgrade/UpgradeSessionManagerModule.s.sol:UpgradeSessionManagerModuleScript --sig "run(address)" "0xE544c1dC66f65967863F03AEdEd38944E6b87309" --rpc-url $GNOSIS_MAINNET_RPC_URL --etherscan-api-key $GNOSIS_MAINNET_ETHERSCAN_API_KEY --verify --verifier-url $GNOSIS_ETHERSCAN_VERIFIER_URL --private-key $PRIVATE_KEY 
```

# Swapper
```shell
$ forge script script/OnRampSwapper.s.sol:OnRampSwapperScript --sig "deploy(address,address,address,address)" 0xf5b509bB0909a69B1c207E495f687a596C168E12 0x0D9B0790E97e3426C161580dF4Ee853E4A7C4607 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270 0xA232F16aB37C9a646f91Ba901E92Ed1Ba4B7b544 --rpc-url $POLYGON_MAINNET_RPC_URL --etherscan-api-key $POLYGON_MAINNET_ETHERSCAN_API_KEY --verify --verifier-url $POLYGON_ETHERSCAN_VERIFIER_URL --private-key $PRIVATE_KEY 
```