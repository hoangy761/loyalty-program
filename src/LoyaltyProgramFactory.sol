// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "./LoyaltyProgram.sol";

contract LoyaltyProgramFactory is Ownable {
    uint32 public loyaltyProgramCount;
    address[] public loyaltyPrograms;

    mapping(address => address[]) public programsByOwner;

    event LoyaltyProgramCreated(
        address indexed creator,
        address indexed programAddress,
        uint32 programIndex
    );

    constructor() Ownable(msg.sender) {}

    function createLoyaltyProgram() external returns (LoyaltyProgram) {
        LoyaltyProgram loyaltyProgram = new LoyaltyProgram();
        loyaltyProgram.transferOwnership(msg.sender);

        // Store the program
        loyaltyPrograms.push(address(loyaltyProgram));
        programsByOwner[msg.sender].push(address(loyaltyProgram));
        loyaltyProgramCount++;

        emit LoyaltyProgramCreated(
            msg.sender,
            address(loyaltyProgram),
            loyaltyProgramCount - 1
        );

        return loyaltyProgram;
    }

    function getAllPrograms() external view returns (address[] memory) {
        return loyaltyPrograms;
    }

    function getProgramsByOwner(
        address owner
    ) external view returns (address[] memory) {
        return programsByOwner[owner];
    }

    function getProgramsCount() external view returns (uint32) {
        return loyaltyProgramCount;
    }
}
