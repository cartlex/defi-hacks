//SPDX-License-Identifier: UNLICENDED
pragma solidity 0.8.21;

import {console2} from "forge-std/Test.sol";
import {ICurve} from "./interfaces/ICurve.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Constants} from "./Constants.sol";

 /**
  * @title  Target Contract
  * @author cartlex
  * @notice This contract is for educational purposes only,
  *         do not use it in production.
  */
contract Target is Constants {
    using SafeERC20 for IERC20;

    ICurve private constant POOL = ICurve(STETH_POOL);
    IERC20 private constant LP_TOKEN = IERC20(LP);

    mapping(address user => uint256 amount) balances;

    function stake(uint256 amount) external {
        IERC20(LP_TOKEN).safeTransferFrom(msg.sender, address(this), amount);
        balances[msg.sender] = balances[msg.sender] + amount;
    }

    function unstake(uint256 amount) external {
        balances[msg.sender] = balances[msg.sender] - amount;
        IERC20(LP_TOKEN).safeTransfer(msg.sender, amount);
    }

    function getReward() external view returns (uint256) {
        uint256 reward = balances[msg.sender] * POOL.get_virtual_price() / 1e18;
    }
}