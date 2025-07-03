// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoyaltyProgram {
    address public owner;
    mapping(address => uint256) public points;

    constructor() {
        owner = msg.sender;
    }
}
