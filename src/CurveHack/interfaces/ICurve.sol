//SPDX-License-Identifier: UNLICENDED
pragma solidity 0.8.21;

interface ICurve {
    function get_virtual_price() external view returns (uint256);

    function addLiquidity(uint256[2] calldata amounts, uint256 min_mint_amount) external payable returns (uint256);

    function removeLiquidity(uint256 lp, uint[2] calldata min_amounts) external view returns (uint256[2] memory);
}