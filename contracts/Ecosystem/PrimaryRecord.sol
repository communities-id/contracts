// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "../MemberRegistry/MemberRouter.sol";
import "../MemberRegistry/MemberProtocolFee.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract PrimaryRecord is Ownable, Pausable, ReentrancyGuard {
    error ErrInvalidBalance();
    error ErrNotPermitted();
    error ErrNativeTransferFailed();
    event PrimaryRecordSet(address indexed _from, bytes32 _baseNode, bytes32 _node);
    struct Record {
        bytes32 baseNode;
        bytes32 node;
    }
    mapping(address => Record) internal _records;
    IMemberRouter internal _router;

    constructor(IMemberRouter router_) {
        _router = router_;
    }

    /**
     * @dev Sets the primary record for the sender's address.
     * The baseNode_ parameter represents the base node of the record,
     * and the node_ parameter represents the node of the record.
     * The function requires payment of a protocol fee, which is determined
     * by calling the getProtocolFee function of the IMemberProtocolFee contract
     * using the PROTOCOL_FEE key of the IMemberRouter contract.
     * The function reverts with the ErrInvalidBalance error if the
     * protocol fee is not equal to the value sent with the transaction.
     * The protocol fee is transferred to the payee address obtained by calling the
     * route function of the IMemberRouter contract with the PROTOCOL_FEE_PAYEE key.
     */
    function setPrimaryRecord(
        bytes32 baseNode_,
        bytes32 node_
    ) external payable whenNotPaused nonReentrant {
        uint256 procotolFee = IMemberProtocolFee(
            _router.route(IMemberRouter.RouterKey.PROTOCOL_FEE)
        ).getProtocolFee(
                address(this),
                IMemberProtocolFee.Operation.SET_PRIMARY
            );
        if (msg.value != procotolFee) revert ErrInvalidBalance();
        address receipt = _router.route(
            IMemberRouter.RouterKey.PROTOCOL_FEE_PAYEE
        );

        (bool success, ) = payable(receipt).call{value: msg.value}("");
        if (!success) revert ErrNativeTransferFailed();

        _records[msg.sender] = Record(baseNode_, node_);
        emit PrimaryRecordSet(msg.sender, baseNode_, node_);
    }

    /**
     * @dev Returns the primary record for the given address. The function
     * retrieves the record from the _records mapping, which maps addresses
     * to Record structs. The Record struct contains two fields:
     * baseNode, which represents the base node of the record, and
     * node, which represents the node of the record.
     * The function returns the Record struct as a memory reference.
     */
    function getPrimaryRecord(
        address address_
    ) public view returns (Record memory) {
        return _records[address_];
    }

    /**
     * @dev Pauses contract functionality. Only callable by the contract owner.
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses contract functionality. Only callable by the contract owner.
     */
    function unpause() external onlyOwner {
        _unpause();
    }
}
