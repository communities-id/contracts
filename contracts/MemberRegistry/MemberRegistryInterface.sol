// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../Library/ERC721A/ERC721A.sol";
import "../CommunityRegistry/CommunityRegistry.sol";
import "./MemberRouter.sol";
import "./MemberTransfer.sol";
import "./MemberTokenomics.sol";
import "hardhat/console.sol";

/**
 * @title MemberRegistryInterfaceCommitment
 * @dev This contract provides functions for creating and validating commitments
 *      related to the member registry.
 */
contract MemberRegistryInterfaceCommitment is EIP712 {
    using ECDSA for bytes32;

    /**
     * @dev Struct representing a commitment related to the member registry.
     */
    struct Commitment {
        address registry;
        string node;
        address owner;
        uint256 day;
        uint256 deadline;
    }

    string public constant COMMITMENT_NAME = "MemberRegistryInterface";
    string public constant COMMITMENT_SCHEMA_VERSION = "1";
    bytes32 public constant COMMITMENT_TYPE_HASH =
        keccak256(
            "Commitment(address registry,string node,address owner,uint256 day,uint256 deadline)"
        );

    constructor() EIP712(COMMITMENT_NAME, COMMITMENT_SCHEMA_VERSION) {}

    /**
     * @dev Returns the hash of the commitment struct.
     * @param commitment_ The commitment struct to be hashed.
     * @return The hash of the commitment struct.
     */
    function getCommitmentDigest(
        Commitment memory commitment_
    ) public view returns (bytes32) {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        COMMITMENT_TYPE_HASH,
                        commitment_.registry,
                        keccak256(bytes(commitment_.node)),
                        commitment_.owner,
                        commitment_.day,
                        commitment_.deadline
                    )
                )
            );
    }

    /**
     * @dev Returns the address of the signer of the commitment.
     * @param commitment_ The commitment struct.
     * @param signature_ The signature of the commitment.
     * @return The address of the signer of the commitment.
     */
    function getCommitmentSignatureSinger(
        Commitment memory commitment_,
        bytes calldata signature_
    ) public view returns (address) {
        return getCommitmentDigest(commitment_).recover(signature_);
    }
}

/**
 * @title IMemberRegistryInterface
 * @dev Interface for a member registry.
 */
interface IMemberRegistryInterface {
    /**
     * @dev Struct representing the information of a node.
     */
    struct NodeInfo {
        uint256 basePrice;
        uint256 commission;
        uint256 input;
    }

    /**
     * @dev Returns the information of a node.
     * @param nodehash_ The hash of the node.
     * @return The information of the node.
     */
    function getNodeInfo(
        bytes32 nodehash_
    ) external view returns (NodeInfo memory);

    function getRenewPrice(
        bytes32 nodehash_,
        address operator_,
        address owner_,
        uint256 days_
    ) external view returns (uint256 base, uint256 commission);

    function getMintPrice(
        bytes32 nodehash_,
        address operator_,
        address owner_,
        uint256 days_
    ) external view returns (uint256 basePrice, uint256 commission);

    function getBurnPrice(
        bytes32 nodehash_,
        address operator_
    ) external view returns (uint256);
}
