// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "account-abstraction/interfaces/IEntryPoint.sol";

import "./Card.sol";
import "./interfaces/IOwnable.sol";
import "./interfaces/ITokenEntryPoint.sol";
import "./interfaces/IWhitelist.sol";
import "./interfaces/IWithdrawable.sol";

/**
 * @title CardManager
 * @dev A factory contract that creates Card contracts.
 */
contract CardManager is IWhitelist {
	Card public cardImplementation;

	event CardCreated(address indexed voucher);

	bool private _initialized = false;

    error AlreadyInitializing();

	/**
	 * @dev Throws if called after initialization.
	 */
	modifier onlyInitializing() {
        if (_initialized) revert AlreadyInitializing();
		_initialized = true;
		_;
	}

	constructor(
		address _owner
	) {
		owner = _owner;
	}

	// TODO: move entrypoint and token entrypoint out of constructor
	function initialize(IEntryPoint _entryPoint, ITokenEntryPoint _tokenEntryPoint, address[] memory _whitelistAddresses) public onlyInitializing {
		cardImplementation = new Card(_entryPoint, _tokenEntryPoint);
        _whitelistVersion = 0;
		_updateWhiteList(_whitelistAddresses);
	}

	/**
	 * @dev Calculates the hash value for a given card.
	 * This function should only be used to test hash values.
	 *
	 * @param serial The serial to be hashed.
	 * @return The calculated hash value.
	 */
	function getCardHash(uint256 serial) public view returns (bytes32) {
		return keccak256(abi.encodePacked(serial, address(this)));
	}

	function createCard(bytes32 cardHash) public returns (Card ret) {
		address addr = getCardAddress(cardHash);

		emit CardCreated(addr);

		uint codeSize = addr.code.length;
		if (codeSize > 0) {
			return Card(payable(addr));
		}
		ret = Card(
			payable(
				new ERC1967Proxy{ salt: cardHash }(
					address(cardImplementation),
					abi.encodeCall(Card.initialize, ((this)))
				)
			)
		);

		// transfer ownership to the card manager
		ret.transferOwnership(address(this));
	}

	/**
	 * calculate the counterfactual address of this card as it would be returned by createCard()
	 */
	function getCardAddress(bytes32 cardHash) public view returns (address) {
		return
			Create2.computeAddress(
				cardHash,
				keccak256(
					abi.encodePacked(
						type(ERC1967Proxy).creationCode,
						abi.encode(address(cardImplementation), abi.encodeCall(Card.initialize, ((this))))
					)
				)
			);
	}

	// helper function for withdrawing from Cards and creating the card if needed
	function withdraw(bytes32 cardHash, IERC20 token, address to, uint256 amount) public {
		address cardAddress = getCardAddress(cardHash);
		bool exists = contractExists(cardAddress);
		if (!exists) {
			createCard(cardHash);
		}

		IWithdrawable card = IWithdrawable(cardAddress);

		card.withdrawTo(token, to, amount);
	}

	// allow card ownership to be given away
	function transferCardOwnership(bytes32 cardHash, address newOwner) public {
		IOwnable card = IOwnable(getCardAddress(cardHash));

		card.transferOwnership(newOwner);
	}

	// ownership management
	address public owner;

	/**
	 * @dev Throws if called by any account other than the owner.
	 */
	modifier onlyOwner() {
		_checkOwner();
		_;
	}

	function _checkOwner() internal view virtual {
		require(owner == msg.sender, "Ownable: caller is not the owner");
	}

	// more gas efficient for updating the whitelist than only using a mapping
	uint256 private _whitelistVersion = 0;
	mapping(address => uint256) private _whitelist;

	/**
	 * @dev Checks if an address is in the whitelist.
	 * @param addr The address to check.
	 * @return A boolean indicating whether the address is in the whitelist.
	 */
	function isWhitelisted(address addr) external view returns (bool) {
		return _whitelist[addr] == _whitelistVersion;
	}

	function _updateWhiteList(address[] memory addresses) internal virtual {
		// bump the version number so that we don't have to clear the mapping
		_whitelistVersion++;

		for (uint i = 0; i < addresses.length; i++) {
			_whitelist[addresses[i]] = _whitelistVersion;
		}
	}

	/**
	 * @dev Updates the whitelist.
	 * @param addresses The addresses to update the whitelist.
	 */
	function updateWhitelist(address[] memory addresses) public onlyOwner {
		_updateWhiteList(addresses);
	}

	function contractExists(address contractAddress) public view returns (bool) {
		uint256 size;	
		// solhint-disable-next-line no-inline-assembly
		assembly {
			size := extcodesize(contractAddress)
		}
		return size > 0;
	}
}
