// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../libraries/Datatypes.sol";
import "./ISubWallet.sol";

interface ISmartWallet {
    function owner() external view returns (address);

    function createSubwallet(
        DataTypes.SubwalletParams calldata params
    ) external returns (ISubWallet);


    function listSubwallets() external view returns (ISubWallet[] memory);
}
