// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Asset} from "../src/Asset.sol";

contract AssetTest is Test {
    Asset public asset; 

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address pranav = makeAddr("pranav");

    function setUp() public {
        vm.prank(bob);
        asset = new Asset();
    }

    function testInitialSupply() public {
        uint256 x = asset.totalSupply();
        assertEq(x,100_000e18);
    }

    function testbalanceof() public {
        uint256 x = asset.balanceOf(bob);
        assertEq(x, 1e23);
    }

    function testTransfer() public {
        vm.prank(bob);
        asset.transfer(alice,1e18);
    }

    function testFailTransfer() public {
        asset.transfer(alice,1e12);
    }

    function testApprove() public {
        vm.prank(bob);
        asset.approve(alice, 11e18);
    }

    function testAllowanceSpend() public {
        vm.prank(bob);
        asset.approve(alice, 11e18);
        vm.prank(alice);
        asset.transferFrom(bob, alice, 8e18);
        uint256 x = asset.balanceOf(alice);
        assertEq(x, 8e18);
    }
}
