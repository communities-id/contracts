// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

interface INodeValidator {
    /**
     * @dev Validates a node string
     * @param registry_ The address of the registry contract associated with the node.
     * @param node_ A string representing the node to be validated.
     * @return A boolean indicating whether or not the node is valid according to the current configuration.
     */
    function validateNode(
        address registry_,
        string calldata node_
    ) external view returns (bool);
}
