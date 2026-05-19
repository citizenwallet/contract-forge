// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { Script, console } from "forge-std/Script.sol";

import { PaymasterNoWhitelist } from "../src/Modules/Community/PaymasterNoWhitelist.sol";

import { Create2 } from "../src/Create2/Create2.sol";
import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract PaymasterNoWhitelistDeploy is Script {
	function deploy(address owner, address sponsor) external {
		uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

		vm.startBroadcast(deployerPrivateKey);

		Create2 factory = Create2(vm.envAddress("CREATE2_FACTORY_ADDRESS"));

		// Deploy the implementation via Create2 so its address is deterministic across chains
		bytes32 implSalt = keccak256(abi.encodePacked("PAYMASTER_NO_WHITELIST_IMPL_1"));
		address implementation = factory.deploy(implSalt, type(PaymasterNoWhitelist).creationCode);

		if (implementation == address(0)) {
			console.log("PaymasterNoWhitelist implementation deployment failed");
			vm.stopBroadcast();
			return;
		}

		// Prepare initialization data
		bytes memory initData = abi.encodeCall(PaymasterNoWhitelist.initialize, (owner, sponsor));

		// Prepare the creation code for the proxy
		bytes memory proxyBytecode = abi.encodePacked(
			type(ERC1967Proxy).creationCode,
			abi.encode(implementation, initData)
		);

		bytes32 proxySalt = keccak256(abi.encodePacked("PAYMASTER_NO_WHITELIST_1"));

		// Deploy the proxy using Create2
		address proxyAddress = factory.deploy(proxySalt, proxyBytecode);

		if (proxyAddress == address(0)) {
			console.log("PaymasterNoWhitelist proxy deployment failed");
			vm.stopBroadcast();
			return;
		}

		console.log("PaymasterNoWhitelist implementation created at: ", implementation);
		console.log("PaymasterNoWhitelist proxy created at: ", proxyAddress);

		vm.stopBroadcast();
	}
}
