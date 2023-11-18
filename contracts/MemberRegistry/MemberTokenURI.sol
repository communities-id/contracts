// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./MemberRouter.sol";
import "./MemberRegistry.sol";
import "../CommunityRegistry/CommunityTokenURI.sol";
import "../CommunityRegistry/CommunityRegistry.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

interface IMemberTokenURI {
    /**
     * @dev Returns the token URI of a given token ID.
     * @param registry_ The address of the member registry containing the token ID.
     * @param tokenId_ The ID of the token to get the URI for.
     * @return A string representing the token URI.
     */
    function tokenURI(
        address registry_,
        uint256 tokenId_
    ) external view returns (string memory);
}
