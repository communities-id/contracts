// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../Library/ERC721A/ERC721A.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../Library/LayerZero/lzApp/NonblockingLzApp.sol";

interface ICommunityTransfer {
    function beforeTokenTransfers(
        address operator,
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) external;
}
