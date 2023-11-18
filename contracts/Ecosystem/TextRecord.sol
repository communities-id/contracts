// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";

contract TextRecord is Ownable, Pausable {
    error ErrNotPermitted();
    error ErrKeyIsNotAllowed();
    struct Key {
        address registry;
        bytes32 node;
        bytes32 key;
        address owner;
    }

    mapping(bytes32 => bool) internal _whitelist;
    mapping(bytes32 => bytes) internal _records;

    constructor() {}

    /**
     * @dev Sets the whitelist for keys.
     * @param keys_ An array of keys to set the whitelist for.
     * @param states_ An array of boolean values indicating whether or not the corresponding key is whitelisted.
     */
    function setWhitelist(
        bytes32[] calldata keys_,
        bool[] calldata states_
    ) external onlyOwner {
        for (uint256 i = 0; i < keys_.length; i++) {
            _whitelist[keys_[i]] = states_[i];
        }
    }

    /**
     * @dev Gets the whitelist status of a key.
     * @param key_ The key to check the whitelist status of.
     * @return A boolean indicating whether or not the key is whitelisted.
     */
    function isWhitelistKey(bytes32 key_) external view returns (bool) {
        return _whitelist[key_];
    }

    /**
     * @dev Sets the values for multiple keys.
     * @param registry_ The address of the member registry contract.
     * @param nodehash_ The nodehash of the node to set the values for.
     * @param keys_ An array of keys to set the values for.
     * @param values_ An array of values to set for the corresponding keys.
     */
    function set(
        address registry_,
        bytes32 nodehash_,
        bytes32[] calldata keys_,
        bytes[] calldata values_
    ) external whenNotPaused {
        address nodeOwner = IMemberRegistry(registry_).ownerOfNode(nodehash_);
        if (msg.sender != nodeOwner) revert ErrNotPermitted();
        for (uint256 i = 0; i < keys_.length; i++) {
            if (!_whitelist[keys_[i]]) revert ErrKeyIsNotAllowed();
            bytes32 hashkey = _calculateHashkey(
                Key({
                    registry: registry_,
                    node: nodehash_,
                    key: keys_[i],
                    owner: nodeOwner
                })
            );
            _records[hashkey] = values_[i];
        }
    }

    /**
     * @dev Gets the values for multiple keys.
     * @param registry_ The address of the member registry contract.
     * @param nodehash_ The nodehash of the node to get the values for.
     * @param keys_ An array of keys to get the values for.
     * @return An array of values corresponding to the keys.
     */
    function get(
        address registry_,
        bytes32 nodehash_,
        bytes32[] calldata keys_
    ) public view returns (bytes[] memory) {
        address nodeOwner = IMemberRegistry(registry_).ownerOfNode(nodehash_);
        bytes[] memory values_ = new bytes[](keys_.length);
        for (uint256 i = 0; i < keys_.length; i++) {
            if (!_whitelist[keys_[i]]) revert ErrKeyIsNotAllowed();
            bytes32 hashkey = _calculateHashkey(
                Key({
                    registry: registry_,
                    node: nodehash_,
                    key: keys_[i],
                    owner: nodeOwner
                })
            );
            values_[i] = _records[hashkey];
        }
        return values_;
    }

    /**
     * @dev Calculates the hashkey for a given key.
     * @param key_ The key to calculate the hashkey for.
     * @return The hashkey for the given key.
     */
    function _calculateHashkey(
        Key memory key_
    ) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(key_.registry, key_.node, key_.key, key_.owner)
            );
    }

    /**
     * @dev Pauses contract functionality. Only callable by the contract owner.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses contract functionality. Only callable by the contract owner.
     */
    function unpause() external onlyOwner {
        _unpause();
    }
}
