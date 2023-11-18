// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../Library/ERC721A/ERC721A.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../Library/LayerZero/lzApp/NonblockingLzApp.sol";
import "./CommunityRegistry.sol";
import "../Ecosystem/NodeValidator.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract CommunityRegistryInterfaceMintCommitment is EIP712 {
    using ECDSA for bytes32;

    struct Commitment {
        string node;
        address owner;
        uint256 deadline;
    }

    string public constant COMMITMENT_NAME =
        "CommunityRegistryInterfaceMintCommitment";
    string public constant COMMITMENT_SCHEMA_VERSION = "1";
    bytes32 public constant COMMITMENT_TYPE_HASH =
        keccak256("Commitment(string node,address owner,uint256 deadline)");

    constructor() EIP712(COMMITMENT_NAME, COMMITMENT_SCHEMA_VERSION) {}

    /**
     * @dev Returns the hashed representation (digest) of a given commitment.
     * @param  commitment_  A Commitment struct containing information about a specific commitment.
     * @return bytes32      Hashed representation (digest) of the given commitment.
     */
    function getCommitmentDigest(
        Commitment memory commitment_
    ) public view returns (bytes32) {
        return
            _hashTypedDataV4(
                keccak256(
                    abi.encode(
                        COMMITMENT_TYPE_HASH,
                        keccak256(bytes(commitment_.node)),
                        commitment_.owner,
                        commitment_.deadline
                    )
                )
            );
    }

    /**
     * @dev Recovers and returns the signer's address from a given signature using a specific committed digest.
     * @param  commitment_  A Commitment struct containing information about a specific commitment.
     * @param  signature_   The signature to recover the signer's address from.
     * @return address      The address of the signer who created the commitment.
     */
    function getCommitmentSignatureSinger(
        Commitment memory commitment_,
        bytes calldata signature_
    ) public view returns (address) {
        return getCommitmentDigest(commitment_).recover(signature_);
    }
}

interface ICommunityRegistryInterface {
    /**
     * @dev Returns the mint price.
     * @return The mint price.
     */
    function getMintPrice() external view returns (uint256);
}
