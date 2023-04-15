// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/contracts/SmartWallet.sol";

contract Deploy is Script {
    SmartWallet public smartwallet;
    function setUp() public {}

    function run() public {
        // vm.broadcast();      // default
        vm.startBroadcast();

        smartwallet = new SmartWallet();

        vm.stopBroadcast();
    }
}

contract Playground is Script {
    SmartWallet public smartwallet;
    function setUp() public {}

    function run() public {
        // vm.broadcast();      // default
        vm.startBroadcast();

        smartwallet = SmartWallet(0x5FbDB2315678afecb367f032d93F642f64180aa3);

        vm.stopBroadcast();
    }
}