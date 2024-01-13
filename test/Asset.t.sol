// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Asset} from "../contracts/Asset.sol";

contract AssetTest is Test {
    Asset public asset; 

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address pranav = makeAddr("pranav");

    function setUp() public {
        asset = new Asset();
    }

    function testInitialSupply() public {
        uint256 x = asset.totalSupply();
        assertEq(x,100_000e18);
    }
}
