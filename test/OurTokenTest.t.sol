// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import {OurToken} from "../src/OurToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";

contract OurtokenTest is Test {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    OurToken public token;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        token = deployer.run();

        vm.prank(msg.sender);

        token.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, token.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        // Bob approves alice to spend tokens on her behalf

        vm.prank(bob);
        token.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        token.transferFrom(bob, alice, transferAmount);

        assertEq(token.balanceOf(alice), transferAmount);
        assertEq(token.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}
