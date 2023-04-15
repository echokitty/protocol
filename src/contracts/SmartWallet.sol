// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../libraries/Datatypes.sol";
import "../interfaces/ISmartWallet.sol";
import "../interfaces/IAuthorizationRegistry.sol";
import "./SubWallet.sol";

contract SmartWallet is ISmartWallet {
    address public owner;
    IAuthorizationRegistry public immutable authorizationRegistry;
    ISubWallet[] public subwallets;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(
        address _owner,
        IAuthorizationRegistry _authorizationRegistry,
        address manager
    ) {
        owner = _owner;
        authorizationRegistry = _authorizationRegistry;
        authorizationRegistry.authorize(manager);
    }

    function createSubwallet(
        DataTypes.SubwalletParams calldata params
    ) external payable onlyOwner returns (ISubWallet) {
        SubWallet subwallet = new SubWallet{value: msg.value}(params);
        subwallets.push(subwallet);
        return subwallet;
    }

    function isAuthorized(address manager) external view returns (bool) {
        return authorizationRegistry.isAuthorized(address(this), manager);
    }

    function changeManager(address newManager) external onlyOwner {
        authorizationRegistry.authorize(newManager);
    }

    function listSubwallets() external view returns (ISubWallet[] memory) {
        return subwallets;
    }
}
