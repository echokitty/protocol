// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../libraries/Datatypes.sol";

interface ISubWallet {
    /// @notice the owner will always be the smart wallet
    function owner() external view returns (address);

    function target() external view returns (address);

    /// @return a list of tokens that are currently in the subwallet
    function listTokens() external view returns (address[] memory);
}
