//SPDX-License-Identifier: UNLICENDED
pragma solidity 0.8.21;

import {console2, Test, StdStyle} from "forge-std/Test.sol";
import {CurveHack} from "../../src/CurveHack/CurveHack.sol";
import {Target} from "../../src/CurveHack/Target.sol";

contract CurveHackTest is Test {
    uint256 private constant VALUE = 10_000e18;
    uint256 private constant DEPOSIT_AMOUNT = 2_000e18;
    uint256 private constant SETUP_AMOUNT = 25e18;
    address user = vm.addr(111);

    CurveHack public curveHack;
    Target public target;

    function setUp() public {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"));
        vm.deal(user, VALUE);

        vm.startPrank(user);
        
        target = new Target();
        curveHack = new CurveHack(target);

        vm.stopPrank();
    }

    function test_pwn() public {
        emit log_named_decimal_uint("user balance", address(user).balance, 18);
        // console2.log();
        vm.startPrank(user);
        curveHack.setup{value: SETUP_AMOUNT}();
        curveHack.pwn{value: DEPOSIT_AMOUNT}();
        vm.stopPrank();
    }
}