// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract LoyaltyProgram is Ownable {
    mapping(address => uint32) public points;
    mapping(address => bool) public isEnrolled;
    uint32 private totalUsers;

    constructor() Ownable(msg.sender) {}

    function addPoints(address user, uint32 amount) external onlyOwner {
        if (points[user] == 0 && !isEnrolled[user]) {
            isEnrolled[user] = true;
            totalUsers = totalUsers + 1;
        }
        points[user] = points[user] + amount;
    }

    function redeemPoints(address user, uint32 amount) external onlyOwner {
        require(points[user] >= amount, "Not enough points");
        points[user] = points[user] - amount;
    }

    function getMyPoints() external view returns (uint32) {
        return points[msg.sender];
    }

    function getTotalUsers() external view returns (uint32) {
        return totalUsers;
    }
}
