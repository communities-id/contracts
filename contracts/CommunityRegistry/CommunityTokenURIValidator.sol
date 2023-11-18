// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";

interface ICommunityTokenURIValidator {
    /**
     * @dev Validates the value of an attribute.
     * @param value_ The value to validate.
     * @return A boolean indicating whether the value is valid.
     */
    function validateValue(string calldata value_) external view returns (bool);

    /**
     * @dev Validates an attribute based on its key, display type, and value.
     * @param key_ The key of the attribute.
     * @param displayType_ The display type of the attribute.
     * @param value_ The value of the attribute.
     * @return A boolean indicating whether the attribute is valid.
     */
    function validateAttribute(
        string memory key_,
        string memory displayType_,
        string memory value_
    ) external view returns (bool);
}
