// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "./MemberRouter.sol";
import "./MemberRegistry.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

interface IMemberTokenomics {
    /**
     * @dev Gets the base and commission price for minting a membership token.
     * @param contractAddress_ The address of the member registry contract.
     * @param operator_ The address of the operator performing the mint.
     * @param owner_ The address that will own the minted token.
     * @param node_ The node hash that the token represents.
     * @param days_ The number of days to mint the membership token for.
     * @return base The base price of the membership token.
     * @return commission The commission fee to charge for buying/selling the membership token.
     */
    function getMintPrice(
        address contractAddress_,
        address operator_,
        address owner_,
        bytes32 node_,
        uint256 days_,
        uint256 x_
    ) external view returns (uint256 base, uint256 commission);

    /**
     * @dev Gets the base and commission price for renewing a membership token.
     * @param contractAddress_ The address of the member registry contract.
     * @param operator_ The address of the operator performing the renew.
     * @param node_ The node hash that the token represents.
     * @ * @param days_ The number of days to renew the membership token for.
     * @return base The base price of the membership token.
     * @return commission The commission fee to charge for buying/selling the membership token.
     */
    function getRenewPrice(
        address contractAddress_,
        address operator_,
        bytes32 node_,
        uint256 days_,
        uint256 x_
    ) external view returns (uint256 base, uint256 commission);

    /**
     * @dev Gets the price for burning a membership token.
     * @param contractAddress_ The address of the member registry contract.
     * @param operator_ The address of the operator performing the burn.
     * @param node_ The node hash that the token represents.
     * @return price The price to burn the membership token.
     */
    function getBurnPrice(
        address contractAddress_,
        address operator_,
        bytes32 node_,
        uint256 x_
    ) external view returns (uint256 price);
}
