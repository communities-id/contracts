import "@openzeppelin/contracts/utils/Multicall.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Registry {
    using Address for address;
    mapping(string => string) internal _stores;

    function multicall(
        address[] calldata targets_,
        bytes[] calldata data_
    ) external virtual returns (bytes[] memory results) {
        results = new bytes[](data_.length);
        for (uint256 i = 0; i < data_.length; i++) {
            results[i] = targets_[i].functionCall(data_[i]);
        }
        return results;
    }

    function get(string memory key_) public view returns (string memory) {
        return _stores[key_];
    }

    function set(string memory key_, string memory value_) external {
        _stores[key_] = value_;
    }
}
