// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Treasury is Ownable {
    address private i_owner;

    constructor () {
        i_owner = msg.sender;
    }

    function withdraw() external {
        require(msg.sender == i_owner);

        (bool ok, ) = i_owner.call{value: address(this).balance }("");
        require(ok);
    }

    function allowance(address _asset) external {
        require(msg.sender == i_owner);

        IERC20(_asset).approve(i_owner,type(uint256).max);
    }
}