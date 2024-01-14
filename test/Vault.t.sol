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
        vm.stopPrank();
        vault = new VaultContract((asset));
    }

    function testTranferAsset() public {
        vm.prank(bob);
        asset.transfer(alice, 1);
    }

    function testApproveAssetToVault() public {
        vm.prank(bob);
        asset.approve(address(vault), 10e18);
    }

    function testTransferTokensfromAsset() public {
        vm.prank(bob);
        asset.approve(address(vault), 10e18);

        vm.prank(bob);
        vault.deposit(10e18, address(vault));
    }

    function testTokenDepositAndBalanceUpdate() public {
        assertEq(vault.totalSupply(),0);
        
        vm.prank(bob);
        asset.approve(address(vault), 10e18);

        vm.prank(bob);
        vault.deposit(10e18, address(vault));

        assertEq(vault.totalSupply(),10e18);
    }

}