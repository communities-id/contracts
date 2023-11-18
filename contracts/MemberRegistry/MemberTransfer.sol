// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

interface IMemberTransfer {
    function beforeTokenTransfers(
        address registry,
        address operator,
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) external;
}
