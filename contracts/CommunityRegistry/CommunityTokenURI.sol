// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../Library/LayerZero/lzApp/NonblockingLzApp.sol";
import "../MemberRegistry/MemberRegistry.sol";
import "../Library/ERC721A/ERC721A.sol";
import "./CommunityRegistry.sol";
import "./CommunityTokenURIValidator.sol";
import "../Library/AttributeUtil.sol";

interface ICommunityTokenURI {
    struct Attribute {
        string key;
        string displayType;
        string value;
    }

    struct CommunityConfig {
        string image;
        string brandImage;
        string brandColor;
        string description;
        string externalUrl;
        Attribute[] attributes;
    }

    /**
     * @dev Retrieves the community configuration associated with a given token ID.
     * @param tokenId_ The ID of the token to retrieve its associated community configuration.
     */
    function getCommunityConfig(
        uint256 tokenId_
    ) external view returns (CommunityConfig memory);

    /**
     * @dev Returns the token URI for a given token ID.
     * @param tokenId_ The ID of the token.
     * @return The token URI.
     */
    function getTokenURI(
        uint256 tokenId_
    ) external view returns (string memory);
}
