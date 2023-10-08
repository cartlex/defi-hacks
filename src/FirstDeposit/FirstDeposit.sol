//SPDX-License-Identifier: UNLICENDED
pragma solidity 0.8.21;

import {MockERC20} from "./MockERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FirstDeposit {
    using SafeERC20 for IERC20;

    error InvalidAmount();
    error InvalidSharesAmount();
    error InsufficientBalance();

    IERC20 public loanToken;
    uint256 public totalShares;
    mapping(address => uint256) public balanceOf;

    constructor(address _loanToken) {
        loanToken = IERC20(_loanToken);
    }

    function deposit(uint256 _tokenAmount) external {
        if (_tokenAmount == 0) revert InvalidAmount();

        uint256 _shares;
        if (totalShares == 0) {
            _shares = _tokenAmount;
        } else {
            _shares = tokenToShares(_tokenAmount, loanToken.balanceOf(address(this)), totalShares, false);
        }

        loanToken.safeTransferFrom(msg.sender, address(this), _tokenAmount);

        balanceOf[msg.sender] = balanceOf[msg.sender] + _shares;
        totalShares = totalShares + _shares;
    }

    function tokenToShares(uint256 _tokenAmount, uint256 _supplied, uint256 _totalShares, bool _roundUpCheck)
        private 
        pure
        returns (uint256)
    {
        if (_supplied == 0) return _tokenAmount;
        uint256 _shares = _tokenAmount * _totalShares / _supplied;
        if (_roundUpCheck) {
            if (_shares * _supplied < _tokenAmount * _totalShares) {
                _shares = _shares + 1;
            }
        }
        return _shares;
    }

    function withdraw(uint256 _shares) external {
        if (_shares == 0) revert InvalidSharesAmount();
        if (balanceOf[msg.sender] < _shares) revert InsufficientBalance();

        uint256 _tokenAmount = _shares * loanToken.balanceOf(address(this)) / totalShares;

        balanceOf[msg.sender] = balanceOf[msg.sender] - _shares;
        totalShares = totalShares - _shares;

        loanToken.safeTransfer(msg.sender, _tokenAmount);
    }
}
