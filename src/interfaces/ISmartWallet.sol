// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../libraries/Datatypes.sol";
import "./ISubWallet.sol";
import "./IAuthorizationRegistry.sol";

interface ISmartWallet {
    event SubwalletCreated(address indexed subwallet, address indexed manager);
    event SubwalletShutdown(address indexed subwallet);

    function owner() external view returns (address);

    function authorizationRegistry()
        external
        view
        returns (IAuthorizationRegistry);

    function createSubwallet(
        bytes32 salt,
        DataTypes.SubwalletParams calldata params
    ) external payable returns (ISubWallet);

    function getPredictedSubwalletAddress(
        bytes32 salt,
        address target
    ) external view returns (address);

    function listSubwallets() external view returns (address[] memory);

    function isAuthorized(address manager) external view returns (bool);
}
