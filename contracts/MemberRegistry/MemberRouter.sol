// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IMemberRouter {
    enum RouterKey {
        UNKNOWN,
        COMMUNITY_REGISTRY,
        NODE_VALIDATOR,
        TRANSFER,
        TOKEN_URI,
        PROTOCOL_FEE_PAYEE,
        TOKENNOMICS,
        PROTOCOL_FEE
    }

    /**
     * @dev Returns the address of the MemberRegistry contract for the given RouterKey.
     * @param key_ The RouterKey to get the MemberRegistry address for.
     * @return The address of the MemberRegistry contract for the given RouterKey as an address.
     */
    function route(RouterKey key_) external view returns (address);
}

/**
 * @title MemberRouter
 * @dev This contract manages the routing of requests to the correct MemberRegistry contract.
 */
contract MemberRouter is IMemberRouter, Ownable {
    error ErrInvalidArguments();
    mapping(RouterKey => address) private _routes;

    constructor() {}

    /**
     * @dev Sets the routes for the given RouterKeys.
     * @param keys_ An array of RouterKeys to set the routes for.
     * @param routes_ An array of addresses to set the routes to.
     * @notice This function can only be called by the contract owner.
     * @notice If the length of the keys_ array does not match the length of the routes_ array, this function reverts with ErrInvalidArguments.
     */
    function setRoutes(
        RouterKey[] calldata keys_,
        address[] calldata routes_
    ) external onlyOwner {
        if (keys_.length != routes_.length) revert ErrInvalidArguments();
        for (uint256 i = 0; i < keys_.length; i++) {
            _routes[keys_[i]] = routes_[i];
        }
    }

    /**
     * @dev Returns the address of the MemberRegistry contract for the given RouterKey.
     * @param key_ The RouterKey to get the MemberRegistry address for.
     * @return The address of the MemberRegistry contract for the given RouterKey as an address.
     */
    function route(RouterKey key_) external view override returns (address) {
        return _routes[key_];
    }
}
