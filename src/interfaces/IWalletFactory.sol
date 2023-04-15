// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IWalletFactory {
    event WalletCreated(address indexed wallet, address indexed manager);

    function createWallet(address manager) external;
}
