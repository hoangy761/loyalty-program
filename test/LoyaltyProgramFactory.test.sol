// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "../src/LoyaltyProgramFactory.sol";
import "../src/LoyaltyProgram.sol";
import {Script, console} from "forge-std/Script.sol";

contract LoyaltyProgramFactoryTest is Test {
    LoyaltyProgramFactory public factory;

    address public userA = address(0x1);
    address public userB = address(0x2);

    function setUp() public {
        // Give some ETH to users for transactions
        vm.deal(userA, 1 ether);
        vm.deal(userB, 1 ether);
    }

    function testUserADeploysFactoryUserBCreatesProgram() public {
        console.log("=== Test Scenario ===");
        console.log("UserA address:", userA);
        console.log("UserB address:", userB);

        // Step 1: UserA deploys LoyaltyProgramFactory
        console.log("\n1. UserA deploys LoyaltyProgramFactory...");
        vm.prank(userA);
        factory = new LoyaltyProgramFactory();

        // Verify userA is the owner of the factory
        assertEq(factory.owner(), userA);
        console.log("[PASS] Factory owner:", factory.owner());
        console.log("[PASS] Expected (userA):", userA);

        // Step 2: UserB creates a new LoyaltyProgram through the factory
        console.log("\n2. UserB creates LoyaltyProgram through factory...");
        vm.prank(userB);
        LoyaltyProgram loyaltyProgram = factory.createLoyaltyProgram();

        // Verify userB is the owner of the created LoyaltyProgram
        assertEq(loyaltyProgram.owner(), userB);
        console.log("[PASS] LoyaltyProgram owner:", loyaltyProgram.owner());
        console.log("[PASS] Expected (userB):", userB);

        // Verify factory count increased
        assertEq(factory.loyaltyProgramCount(), 1);
        console.log("[PASS] Factory count:", factory.loyaltyProgramCount());

        // Step 3: Test that userB can actually use their LoyaltyProgram
        console.log("\n3. Testing userB can manage their LoyaltyProgram...");
        address customer = address(0x3);

        vm.prank(userB); // userB adds points to customer
        loyaltyProgram.addPoints(customer, 100);

        // Verify points were added
        assertEq(loyaltyProgram.points(customer), 100);
        assertEq(loyaltyProgram.isEnrolled(customer), true);
        assertEq(loyaltyProgram.getTotalUsers(), 1);

        console.log("[PASS] Customer points:", loyaltyProgram.points(customer));
        console.log(
            "[PASS] Customer enrolled:",
            loyaltyProgram.isEnrolled(customer)
        );
        console.log(
            "[PASS] Total users in program:",
            loyaltyProgram.getTotalUsers()
        );

        // Step 4: Test that userA cannot control userB's LoyaltyProgram
        console.log("\n4. Testing access control...");
        vm.prank(userA); // userA tries to add points (should fail)
        vm.expectRevert();
        loyaltyProgram.addPoints(customer, 50);
        console.log(
            "[PASS] UserA correctly cannot control userB's loyalty program"
        );
    }

    function testMultipleUsersCreatePrograms() public {
        console.log("\n=== Multiple Users Test ===");

        // UserA deploys factory
        vm.prank(userA);
        factory = new LoyaltyProgramFactory();

        // UserB creates first program
        vm.prank(userB);
        LoyaltyProgram program1 = factory.createLoyaltyProgram();

        // UserA creates second program (using their own factory)
        vm.prank(userA);
        LoyaltyProgram program2 = factory.createLoyaltyProgram();

        // Verify ownership
        assertEq(program1.owner(), userB);
        assertEq(program2.owner(), userA);

        // Verify count
        assertEq(factory.loyaltyProgramCount(), 2);

        console.log(
            "[PASS] Program1 owner (should be userB):",
            program1.owner()
        );
        console.log(
            "[PASS] Program2 owner (should be userA):",
            program2.owner()
        );
        console.log(
            "[PASS] Total programs created:",
            factory.loyaltyProgramCount()
        );
    }

    function testTrackingProgramsByFactory() public {
        console.log("\n=== Testing Program Tracking by Factory ===");

        // UserA deploys factory
        vm.prank(userA);
        factory = new LoyaltyProgramFactory();
        console.log("Factory address:", address(factory));
        console.log("UserA address:", userA);
        console.log("UserB address:", userB);

        // UserB creates 2 programs
        vm.prank(userB);
        LoyaltyProgram program1 = factory.createLoyaltyProgram();

        vm.prank(userB);
        LoyaltyProgram program2 = factory.createLoyaltyProgram();

        // UserA creates 1 program
        vm.prank(userA);
        LoyaltyProgram program3 = factory.createLoyaltyProgram();

        console.log("\nCreated Programs:");
        console.log("Program1 (created by userB):", address(program1));
        console.log("Program2 (created by userB):", address(program2));
        console.log("Program3 (created by userA):", address(program3));

        // Test getAllPrograms
        address[] memory allPrograms = factory.getAllPrograms();
        assertEq(allPrograms.length, 3);
        console.log("\nAll programs count:", allPrograms.length);
        console.log("All program addresses:");
        for (uint i = 0; i < allPrograms.length; i++) {
            console.log("  Program", i + 1, ":", allPrograms[i]);
        }

        // Test that individual users have no programs tracked under their addresses
        address[] memory userAPrograms = factory.getProgramsByOwner(userA);
        address[] memory userBPrograms = factory.getProgramsByOwner(userB);
        assertEq(userAPrograms.length, 1);
        assertEq(userBPrograms.length, 2);
        console.log(
            "Programs tracked under userA address:",
            userAPrograms.length
        );
        console.log(
            "Programs tracked under userB address:",
            userBPrograms.length
        );

        // Verify program ownership is still correct
        assertEq(program1.owner(), userB);
        assertEq(program2.owner(), userB);
        assertEq(program3.owner(), userA);
        console.log("\nProgram ownership verification:");
        console.log("Program1 owner:", program1.owner(), "(should be userB)");
        console.log("Program2 owner:", program2.owner(), "(should be userB)");
        console.log("Program3 owner:", program3.owner(), "(should be userA)");

        console.log("\n[PASS] Factory tracking works correctly!");
        console.log(
            "Note: All programs are tracked by factory address, not individual owner addresses"
        );
    }
}
