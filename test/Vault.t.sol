// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console2 } from "forge-std/Test.sol";
import { Vault } from "../src/Vault.sol";
import { ERC20mock } from "./mocks/ERC20.mock.sol";

contract VaultTest is Test {
    Vault public vault;
    ERC20mock token;

    address deployer;
    address alice;

    function setUp() public {
        deployer = makeAddr("deployer");
        alice = makeAddr("alice");
        vm.startPrank(deployer);

        token = new ERC20mock();
        vault = new Vault(token);

        token.transfer(address(vault), 50000 * 10 ** token.decimals());
        vm.stopPrank();
    }

    function test_amI() public {
        assertEq(deployer, vault.owner());
    }

    function test_transferOwnership() public {
        vm.startPrank(deployer);
        vault.transferOwnership(alice);
        assertEq(alice, vault.owner());
        vm.stopPrank();
    }

    function test_returnBalance() public {
        assertEq(vault.checkBalance(address(token)), token.balanceOf(address(vault)));
    }

    function test_revertIfNotOwnerTryWithdrawAnyTokens() public {
        vm.startPrank(alice);
        vm.expectRevert();
        vault.withdrawToken(address(token), 10);
    }

    function test_revertIfNotOwnerTryWithdrawOceanSaviorTokens() public {
        vm.expectRevert();
        vault.withdrawOSR(10);
    }

    function test_ownerCanWithdrawAnyTokens() public {
        vm.startPrank(deployer);
        vault.withdrawToken(address(token), 10);
    }
}
