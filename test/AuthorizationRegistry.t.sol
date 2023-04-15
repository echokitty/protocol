// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/contracts/AuthorizationRegistry.sol";

contract AuthorizationRegistryTest is Test {
    AuthorizationRegistry public authorizationRegistry;

    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public charlie = makeAddr("charlie");

    function setUp() public {
        authorizationRegistry = new AuthorizationRegistry();
    }

    function testAuthorize() public {
        vm.prank(alice);
        authorizationRegistry.authorize(bob);
        assertEq(authorizationRegistry.authorizedFor(alice), bob);
        address[] memory managedByBob = authorizationRegistry
            .addressesManagedBy(bob);
        assertEq(managedByBob.length, 1);
        assertEq(managedByBob[0], alice);
    }

    function testChangeAuthorization() public {
        vm.prank(alice);
        authorizationRegistry.authorize(bob);
        vm.prank(alice);
        authorizationRegistry.authorize(charlie);
        assertEq(authorizationRegistry.authorizedFor(alice), charlie);
        address[] memory managedByBob = authorizationRegistry
            .addressesManagedBy(bob);
        assertEq(managedByBob.length, 0);
        address[] memory managedByCharlie = authorizationRegistry
            .addressesManagedBy(charlie);
        assertEq(managedByCharlie.length, 1);
        assertEq(managedByCharlie[0], alice);
    }
}
