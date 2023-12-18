// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20mock is ERC20 {
    constructor() ERC20("ERC20mock", "MCK") {
        _mint(msg.sender, 100000 * 10 ** decimals());
    }
}
