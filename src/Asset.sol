// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Asset is ERC20 {

    constructor() ERC20("Asset Token", "ASS") {
        _mint(msg.sender, 100_000 * (10 ** decimals()));
    }

    
}