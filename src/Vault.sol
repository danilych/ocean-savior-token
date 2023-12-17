// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Vault
 *
 * @notice An implementation of smart contract to collect and withdraw fees from transfers OceanSavior token. 
 
 */
contract Vault is Ownable {
    using SafeERC20 for IERC20;

    // @notice function for withdraw tokens from Vault
    // @param token address of token which should be withdrawn
    function withdraw(address token, uint256 amount) external onlyOwner {
        IERC20(token).safeTransfer(_msgSender(), amount);
    }

    // @notice view function for checking token balance in Vault
    // @param token address of ERC20 token which balance should be checked
    function checkBalance(address token) public view returns (uint256){
        return IERC20(token).balanceOf(address(this));
    }
}
