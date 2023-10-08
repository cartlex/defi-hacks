//SPDX-License-Identifier: UNLICENDED
pragma solidity 0.8.21;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title  MockERC20 Contract
 * @author cartlex
 * @notice This contract is for educational purposes only,
 *         do not use it in production.
 */
contract MockERC20 is ERC20 {

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
