// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { ERC20Burnable } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract Token is ERC20, ERC20Burnable, Ownable {
    // @notice address of Vault contract for holding transfer fee.
    address vault;

    // @notice percent of transfer fee which should be moved to the vault.
    uint16 collectorTax;

    // @notice percent of transfer fee which should be burned.
    uint16 burnTax;

    error InvalidValue();

    constructor(uint16 collectorTax_, uint16 burnTax_) ERC20("OceanSavior", "OSR") {
        if (collectorTax_ + burnTax_ < 0 || collectorTax_ + burnTax_ > 1000) {
            revert InvalidValue();
        }
        collectorTax = collectorTax;
        burnTax = burnTax_;

        _mint(msg.sender, 1_000_000_000 * 10 ** decimals());
    }

    function updateVault(address vault_) external onlyOwner {
        if (vault_ == address(0)) revert InvalidValue();
        vault = vault_;
    }

    function updateCollectorTax(uint16 collectorTax_) external onlyOwner {
        if (collectorTax_ + burnTax < 0 || collectorTax_ + burnTax > 1000) {
            revert InvalidValue();
        }

        collectorTax = collectorTax_;
    }

    function updateBurnTax(uint16 burnTax_) external onlyOwner {
        if (collectorTax + burnTax_ < 0 || collectorTax + burnTax_ > 1000) {
            revert InvalidValue();
        }

        burnTax = burnTax_;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        uint256 tax = (amount * collectorTax) / 1000;
        uint256 toBurn = (amount * burnTax) / 1000;

        unchecked {
            amount = amount - tax - toBurn;
        }

        if (tax > 0) super._transfer(from, address(vault), tax);

        if (toBurn > 0) super._burn(from, toBurn);

        super._transfer(from, to, amount);
    }
}
