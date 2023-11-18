// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "../CommunityRegistry/CommunityRegistry.sol";
import "./MemberRegistryInterface.sol";

interface ICommunityRegistryInterface {
    struct Commitment {
        string node;
        address owner;
        uint256 deadline;
    }

    function signatureMint(
        Commitment calldata commitment_,
        bytes calldata signature_,
        address authorizedRegistryInterface_,
        address manualOwner_
    ) external payable returns (uint256);
}

interface IMemberRegistryInterfaceFactory {
    function getMemberRegistryInterface(
        bytes32 nodehash_
    ) external view returns (address);
}
