// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract ChangeBalanceTrap is ITrap {
    address public constant target = 0x923F3f2c0EB6a875C965a1EaCfD7Bf1629c214b3;
    uint256 public constant thresholdDecrease = 0.03 ether;

    function collect() external view override returns (bytes memory) {
        return abi.encode(target.balance);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length < 2) return (false, "Insufficient data");

        uint256 currentBalance = abi.decode(data[0], (uint256));
        uint256 previousBalance = abi.decode(data[1], (uint256));

        if (previousBalance > currentBalance && (previousBalance - currentBalance) >= thresholdDecrease) {
            return (true, "Balance decreased significantly");
        }

        return (false, "");
    }

    function checkAndLogAnomaly(bytes[] calldata data) external {
        (bool response, bytes memory message) = this.shouldRespond(data);
        if (response) {
            emit AnomalyDetected(string(message));
        }
    }

    event AnomalyDetected(string message);
}
