// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/ISmartWallet.sol";
import "../libraries/Datatypes.sol";

interface ISubWallet {
    /// @notice the parent smart wallet
    function parentWallet() external view returns (ISmartWallet);

    function target() external view returns (address);

    function createdAt() external view returns (uint256);

    function initialValue() external view returns (uint256);

    function tearDown(DataTypes.RawSwap[] memory swaps) external;

    /// @return a list of tokens that are currently in the subwallet
    function listTokens() external view returns (address[] memory);

    function executeSwap(DataTypes.RawSwap memory swap) external;
}
