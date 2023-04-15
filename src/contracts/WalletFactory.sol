// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../interfaces/IWalletFactory.sol";

import "./SmartWallet.sol";

contract WalletFactory is IWalletFactory {
    IAuthorizationRegistry public immutable authorizationRegistry;
    mapping(address => address) internal _wallets;

    constructor(IAuthorizationRegistry _authorizationRegistry) {
        authorizationRegistry = _authorizationRegistry;
    }

    function createWallet(address manager) external {
        require(_wallets[msg.sender] == address(0), "wallet already created");
        SmartWallet wallet = new SmartWallet(
            msg.sender,
            authorizationRegistry,
            manager
        );
        _wallets[msg.sender] = address(wallet);
        emit WalletCreated(address(wallet), manager);
    }

    function getWalletFor(address account) external view returns (address) {
        return _wallets[account];
    }
}
