// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library DataTypes {
    /// @notice this is used to call a contract using raw data
    /// i.e. to call the 1inch router with data returned by the 1inch API
    struct Call {
        address target;
        bytes data;
        uint256 value;
    }

    struct RawSwap {
        Call call;
        address outputToken;
    }

    struct SubwalletParams {
        /// @notice account followed by this subwallet
        address target;
        /// @notice Amount of ETH to transfer to the subwallet
        uint256 amount;
        /// @notice List of initial swaps to do within the subwallet
        /// this will be used to initially swap funds
        DataTypes.RawSwap[] swaps;
    }
}
