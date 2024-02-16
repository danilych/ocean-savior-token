// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Vault
 *
 * @notice An implementation of smart contract to collect and withdraw fees from transfers OceanSavior token.
 */
contract Vault is Ownable {
    using SafeERC20 for IERC20;

    // @notice OceanSavior token
    IERC20 token;

    constructor(IERC20 token_) {
        token = token_;
    }

    // @notice function for withdraw OceanSavior tokens from Vault
    // @param amount value of tokens which sender want to withdraw
    function withdrawOSR(uint256 amount) external onlyOwner {
        token.safeTransfer(_msgSender(), amount);
    }

    // @notice function for withdraw any ERC20 tokens from Vault
    // @param token_ address of token which should be withdrawn
    // @param amount value of tokens which sender want to withdraw
    function withdrawToken(address token_, uint256 amount) external onlyOwner {
        IERC20(token_).safeTransfer(_msgSender(), amount);
    }

    // @notice view function for checking token balance in Vault
    // @param token_ address of ERC20 token which balance should be checked
    function checkBalance(address token_) public view returns (uint256) {
        return IERC20(token_).balanceOf(address(this));
    }
}
