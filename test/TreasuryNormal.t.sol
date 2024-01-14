// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Treasury} from "../src/Treasury.sol";
import {Asset} from "../src/Asset.sol";

contract TreasuryTest is Test {

    Treasury public treasury;
    
    // for test 
    Asset public asset;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    address pranav = makeAddr("pranav");

    function setUp() public {
        vm.startPrank(bob);
        treasury = new Treasury();
        asset = new Asset();
        vm.stopPrank();
    }

    function testchecknormalDeposit() public {
        assertEq(address(treasury).balance, 0);
        
        hoax(alice,10e18);
        address(treasury).call{value: 5e18}("");

        assertEq(address(treasury).balance, 5e18);
    }

    function testchecknormalWIthdrawal() public {
        assertEq(address(treasury).balance, 0);
        
        hoax(alice,10e18);
        address(treasury).call{value: 5e18}("");

        assertEq(address(treasury).balance, 5e18);

        vm.prank(bob);
        treasury.withdraw();

        assertEq(address(bob).balance, 5e18);
        assertEq(address(treasury).balance, 0);
    }

    function testforErc20TranfertoTreasury() public {
        vm.prank(bob);
        asset.transfer(address(treasury), 10e18);

        assertEq(asset.balanceOf(address(treasury)), 10e18);
    }

    function testforwithdrawalfromTreasury() public {
        vm.startPrank(bob);
        asset.transfer(address(treasury), 10e18);

        assertEq(asset.balanceOf(bob), 100000e18 - 10e18);
        treasury.allowanceSpend(address(asset));

        assertEq(treasury.owner(), bob);
        
        // asset.transferFrom(bob, bob, 10e18);
        assertEq(asset.balanceOf(bob), 100000e18);
        vm.stopPrank();
    }
}