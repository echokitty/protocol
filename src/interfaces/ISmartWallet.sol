// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../libraries/Datatypes.sol";
import "./ISubWallet.sol";
import "./IAuthorizationRegistry.sol";

interface ISmartWallet {
    function owner() external view returns (address);

    function authorizationRegistry()
        external
        view
        returns (IAuthorizationRegistry);

    function createSubwallet(
        DataTypes.SubwalletParams calldata params
    ) external payable returns (ISubWallet);

    function listSubwallets() external view returns (ISubWallet[] memory);

    function isAuthorized(address manager) external view returns (bool);
}
