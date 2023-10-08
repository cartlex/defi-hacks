//SPDX-License-Identifier: UNLICENDED
pragma solidity 0.8.21;

import {console2, Test, StdStyle} from "forge-std/Test.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {FirstDeposit} from "../../src/FirstDeposit/FirstDeposit.sol";
import {MockERC20} from "../../src/FirstDeposit/MockERC20.sol";

contract FirstDepositTest is Test {
    using SafeERC20 for IERC20;

    MockERC20 mockERC20;
    FirstDeposit vault;

    uint256 private constant USER1_INITIAL_TOKEN_AMOUNT = 1e18 + 1;
    uint256 private constant USER2_INITIAL_TOKEN_AMOUNT = 2e18;
    uint256 private constant VAULT_MINT_AMOUNT = 10_000e18;

    address public user1 = vm.addr(111);
    address public user2 = vm.addr(222);

    function setUp() public {
        mockERC20 = new MockERC20("Token","TKN");

        vault = new FirstDeposit(address(mockERC20));

        mockERC20.mint(user1, USER1_INITIAL_TOKEN_AMOUNT);
        mockERC20.mint(user2, USER2_INITIAL_TOKEN_AMOUNT);
        // mockERC20.mint(address(vault), VAULT_MINT_AMOUNT);
    }

    function test_FirstDeposit() public {
        vm.startPrank(user1);
        IERC20(mockERC20).safeIncreaseAllowance(address(vault), 1);

        emit log_named_decimal_uint("Pool balance before user1 deposit: ", mockERC20.balanceOf(address(vault)), 18);
        console2.log(StdStyle.magenta("========================================================="));

        vault.deposit(1);
        emit log_named_decimal_uint("Pool balance after user1 deposit: ", mockERC20.balanceOf(address(vault)), 18);
        console2.log(StdStyle.magenta("========================================================="));

        IERC20(mockERC20).safeTransfer(address(vault), 1 ether);

        emit log_named_decimal_uint("Pool balance after user1 direct transfer: ", mockERC20.balanceOf(address(vault)), 18);
        console2.log(StdStyle.magenta("========================================================="));

        vm.stopPrank();

        vm.startPrank(user2);
        IERC20(mockERC20).safeIncreaseAllowance(address(vault), 2 ether);
        vault.deposit(2 ether);

        emit log_named_decimal_uint("Pool balance after user2 deposit: ", mockERC20.balanceOf(address(vault)), 18);
        console2.log(StdStyle.magenta("========================================================="));

        emit log("since user1 has same amount of shares as user2, user1 can withdrow 50% pool tokens");

        vm.stopPrank();
        vm.startPrank(user1);
        vault.withdraw(1);
        console2.log(StdStyle.magenta("========================================================="));
        emit log_named_decimal_uint("user1 balance after withdraw: ", mockERC20.balanceOf(user1), 18);

        vm.stopPrank();
    }

    receive() external payable {}
}