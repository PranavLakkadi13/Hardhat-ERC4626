// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Asset} from "../src/Asset.sol";
import {VaultContract} from "../src/VaultContract.sol";
import {Asset8Decimal} from "../src/Asset8decimal.sol";

contract VaultTest is Test {

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address pranav = makeAddr("pranav");

    Asset asset;
    VaultContract vault;
    Asset8Decimal asset8decimal;
    VaultContract vault8;
    
    function setUp() public {
        vm.startPrank(bob);
        asset = new Asset();
        asset8decimal = new Asset8Decimal();
        vm.stopPrank();
        vault = new VaultContract(asset);
        vault8 = new VaultContract(asset8decimal);
    }

    ////////////////////////////////////////////////////////
    ////////    Test for Asset with 18 decimal    //////////
    ////////                                      //////////
    ////////////////////////////////////////////////////////

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
        assertEq(vault.totalAssets(),0);
    }
    
    function testTokenShareMints2MultiAccount() public {
        vm.prank(bob);
        asset.transfer(alice,100e18);
        
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

        vm.prank(alice);
        asset.approve(address(vault), 100e18);

        assertEq(vault.balanceOf(address(alice)),0);

        vm.prank(alice);
        vault.deposit(20e18,address(alice));

        assertEq(vault.balanceOf(alice),20e18);

        vm.prank(alice);
        vault.deposit(20e18,address(alice));

        assertEq(vault.balanceOf(alice),40e18);
    }

    function testcheckinggetterfunction() public {
        vm.prank(bob);
        asset.approve(address(vault), 20e18);

        vm.prank(bob);
        uint256 x = vault.deposit(10e18, bob);

        uint256 y = vault.convertToShares(10e18);
        assertEq(x,y);

        uint256 z = vault.convertToAssets(10e18);
        assertEq(z,x);

        assertEq(vault.maxMint(address(0)),type(uint256).max);
        assertEq(vault.maxWithdraw(alice),0);
        assertEq(vault.maxWithdraw(bob),10e18);

        require(vault.totalAssets() > 0 || vault.totalSupply() > 0);
        assertEq(vault.maxDeposit(bob), type(uint256).max);
    }

    function testForPreviewFunction() public {
        vm.prank(bob);
        asset.approve(address(vault), 20e18);

        vm.prank(bob);
        uint256 x = vault.deposit(10e18, bob);

        uint256 z = vault.previewDeposit(10e18);
        assertEq(x,z);

        uint256 a = vault.previewMint(10e18);
        assertEq(x,a);

        uint256 b = vault.previewRedeem(10e18);
        assertEq(x,b);

        uint256 c = vault.previewWithdraw(10e18);
        assertEq(x,c);
    }


    ///////////////////////////////////////////////////////
    ////////    Test for Asset with 8 decimal     /////////
    ////////                                      /////////
    ///////////////////////////////////////////////////////

    function testBasicTranferAndApprovefunctions() public {
        vm.prank(bob);
        asset8decimal.transfer(alice, 10e8);

        assertEq(asset8decimal.balanceOf(bob),99990e8);
    }

    function testdeposittokensinvault() public {
        vm.prank(bob);
        asset8decimal.approve(address(vault), 100e8);

        vm.prank(bob);
        vault8.deposit(10e8, bob);
    }

    // function testSharesMint() public {
    //     vm.prank(bob);
    //     asset8decimal.approve(address(vault), 100e8);

    //     vm.prank(bob);
    //     vault.deposit(100e8, bob);

    //     uint256 x = vault.balanceOf(bob);
    //     assertEq(x, 100e8);
    // }
}