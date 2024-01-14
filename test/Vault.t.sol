// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
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

    function testTokenShareMints() public {
        assertEq(vault.balanceOf(bob),0);
        
        vm.prank(bob);
        asset.approve(address(vault), 10e18);

        vm.prank(bob);
        uint256 x = vault.deposit(10e18, bob);

        
        // console.log("The amount of shares minted " , x);

        assertEq(vault.balanceOf(bob), x);
    }

    function testTokenShareMints2() public {
        assertEq(vault.balanceOf(bob),0);
        
        vm.prank(bob);
        asset.approve(address(vault), 20e18);

        vm.prank(bob);
        uint256 x = vault.deposit(10e18, bob);

        
        // console.log("The amount of shares minted " , x);

        assertEq(vault.balanceOf(bob), x);

        assertEq(vault.totalSupply(), 10e18);

        vm.prank(bob);
        uint256 y = vault.deposit(10e18, bob);

        // console.log("The amount of shares minted " , y);

        assertEq(vault.balanceOf(bob), y + x);
        assertEq(vault.totalSupply(),20e18);
    }

    function testredeemTokens() public {
        vm.startPrank(bob);
        asset.approve(address(vault), 20e18);
        
        vault.deposit(10e18, bob);

        assertEq(vault.totalSupply(),10e18);

        vault.withdraw(10e18, bob, bob);

        vm.stopPrank();

        assertEq(vault.totalAssets(),0);
    }

    function testRedeemfunction() public {
        vm.startPrank(bob);
        asset.approve(address(vault), 20e18);
        
        vault.deposit(10e18, bob);

        assertEq(vault.totalSupply(),10e18);

        vault.redeem(10e18, bob, bob);

        vm.stopPrank();
        assertEq(vault.totalAssets(),0);
    }

    function testGlobalStateValues() public {
        assertEq(vault.asset(), address(asset));
        assertEq(vault.decimals(),18);
        assertEq(vault.name(), "Vault Token");
        assertEq(vault.symbol(), "VLT");
    }
    
}