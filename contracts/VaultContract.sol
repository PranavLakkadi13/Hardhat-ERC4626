// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract VaultContract is ERC4626 {

    /**
     * @param _asset it is the address of an already existing asset or Token (ERC20,ERC777)
     */
    constructor(IERC20Metadata _asset) ERC4626(_asset) ERC20("Vault Token", "VLT") {

    }
}