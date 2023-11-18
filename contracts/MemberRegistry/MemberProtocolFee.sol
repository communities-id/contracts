// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IMemberProtocolFee {
    enum Operation {
        UNKNOWN,
        MINT,
        RENEW,
        LOCK,
        BURN,
        SET_PRIMARY
    }

    /**
     * @dev Gets the protocol fee for the specified operation.
     * @param registry_ The address of the member registry contract.
     * @param operation_ The operation to get the protocol fee for.
     * @return The protocol fee for the specified operation.
     */
    function getProtocolFee(
        address registry_,
        Operation operation_
    ) external view returns (uint256);

    /**
     * @dev Gets the interface fee rate for the specified operation.
     * @param registry_ The address of the member registry contract.
     * @param operation_ The operation to get the interface fee rate for.
     * @return The interface fee rate for the specified operation.
     */
    function getInterfaceFeeRate(
        address registry_,
        Operation operation_
    ) external view returns (uint256);

    /**
     * @dev Gets the interface fee swap unit for the specified registry.
     * @param registry_ The address of the member registry contract.
     * @return The interface fee swap unit for the specified registry.
     */
    function getInterfaceFeeSwapUnit(
        address registry_
    ) external view returns (uint256);
}
