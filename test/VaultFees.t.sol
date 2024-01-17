// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.8;

import {Test} from "forge-std/Test.sol";
import {Asset} from "../src/Asset.sol";
import {Treasury} from "../src/Treasury.sol";
import {VaultWithFee} from "../src/VaultContractFees.sol";
import "forge-std/console.sol";

contract VaultFeeTest is Test {

    VaultWithFee vault;
    Asset asset;
    Treasury treasury;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address pranav = makeAddr("pranav");
    address feeReceiver = makeAddr("FeeReceiver");

    function setUp() public {
        vm.startPrank(bob);
        asset = new Asset();
        treasury = new Treasury();
        vault = new VaultWithFee(asset,10,address(treasury));
        vm.stopPrank();
    }

    function testDepositandSharesMint() public {
        vm.startPrank(bob);
        asset.approve(address(vault), 100e18);

        console.log(vault.owner());

        vault.deposit(100e18, bob);
        vm.stopPrank();

        uint256 x = vault.balanceOf(bob);
        require(x > 0 );
        console.log("The shares minted are : ", x);
    }

    function testDepositAndBalanceOfTreasury() public {
        vm.startPrank(bob);
        asset.approve(address(vault), 100e18);
    
        vault.deposit(100e18, bob);
        vm.stopPrank();

        uint256 x = asset.balanceOf(address(treasury));
        require(x > 0);
    }

    function testWIthdraw() public {
        vm.startPrank(bob);
        asset.approve(address(vault), 100e18);
    
        vault.deposit(100e18, bob);
        vm.stopPrank();

        uint256 x = vault.balanceOf(bob);
        require(x > 0 );
        console.log("The shares minted are      : ", x);

        uint y = vault.previewWithdraw(asset.balanceOf(address(vault)));
        assertNotEq(y, vault.balanceOf(bob));

        vm.prank(bob);
        vault.withdraw(98e18, bob, bob);

        uint256 z = asset.balanceOf(address(treasury));
        console.log("The amount of fee genrated : ", z);
    }

    function testRedeemTokens() public {
        vm.startPrank(bob);
        asset.approve(address(vault), 100e18);
    
        vault.deposit(100e18, bob);
        vm.stopPrank();

        uint256 x = vault.balanceOf(bob);
        require(x > 0 );
        console.log("The shares minted are      : ", x);

        uint y = vault.previewWithdraw(asset.balanceOf(address(vault)));
        assertNotEq(y, vault.balanceOf(bob));

        vm.prank(bob);
        vault.redeem(98e18, bob, bob);

        assertTrue(vault.balanceOf(bob) > 0);
    }

    function testRedeemTokensOnbehalf() public {
        vm.startPrank(bob);
        asset.approve(address(vault), 100e18);
    
        vault.deposit(100e18, bob);

        vault.approve(alice,100e18);
        vm.stopPrank();

        uint256 x = vault.balanceOf(bob);
        require(x > 0 );
        console.log("The shares minted are      : ", x);

        uint y = vault.previewWithdraw(asset.balanceOf(address(vault)));
        assertNotEq(y, vault.balanceOf(bob));

        uint256 z = vault.previewRedeem(vault.balanceOf(bob));
        assert(y > z);

        vm.prank(alice);
        vault.redeem(49e18, alice, bob);

        vm.prank(alice);
        vault.withdraw(495e17, alice, bob);

        assertTrue(vault.balanceOf(bob) > 0);
    }

    function testTreasuryWithdrwal() public {
        vm.startPrank(bob);
        asset.approve(address(vault), 100e18);
    
        vault.deposit(100e18, bob);

        vault.approve(alice,100e18);
        vm.stopPrank();

        vm.prank(alice);
        vault.redeem(99e18, pranav, bob);

        assert(asset.balanceOf(address(treasury)) > 0);

        vm.prank(bob);
        treasury.transferOwnership(alice);

        assertEq(asset.balanceOf(alice),0);

        uint256 x = asset.balanceOf(address(treasury));

        vm.prank(alice);
        treasury.allowanceSpend(address(asset), x);

        // vm.prank(alice);
        // asset.transferFrom(address(treasury), alice, x);

        assertEq(x, asset.balanceOf(address(alice)));
    }
    
    function testCheckPreviewFunction() public view  {
        uint256 x = vault.previewMint(100e18);
        console.log("The vaule of shares minted " , x);
        assert(x >= 100e18);

        uint256 y = vault.previewDeposit(100e18);
        assert(y <= 100e18);
    }

    function testTheGetterFunctions() public {
        uint8 x = vault.decimals();
        assert(x == 18);

        string memory name = vault.name();
        assertEq(name, "Vault Token");
    }

}