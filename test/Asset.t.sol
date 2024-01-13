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
}
