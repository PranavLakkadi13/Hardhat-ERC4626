// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Treasury is Ownable {

    constructor () {
    }

    function withdraw() external {
        require(msg.sender == owner());

        (bool ok, ) = owner().call{value: address(this).balance }("");
        require(ok);
    }

    function allowanceSpend(address _asset , uint256 _amount) external {
        require(msg.sender == owner(),"only owner can call this function");

        IERC20(_asset).transfer(owner(),_amount);
    }

    receive() external payable {}
}