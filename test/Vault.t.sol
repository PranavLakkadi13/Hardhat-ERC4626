// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Asset} from "../src/Asset.sol";
import {VaultContract} from "../src/VaultContract.sol";

contract VaultTest is Test {

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address pranav = makeAddr("pranav");

    Asset asset;
    VaultContract vault;
    
    function setUp() public {
        vm.startPrank(bob);
        asset = new Asset();
        vault = new VaultContract(asset);
        vm.stopPrank();
    }
}