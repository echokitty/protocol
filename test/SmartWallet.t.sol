// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/contracts/SmartWallet.sol";
import "../src/contracts/AuthorizationRegistry.sol";
import "../src/interfaces/ISubWallet.sol";
import "../src/libraries/Datatypes.sol";

contract SmartWalletTest is Test {
    SmartWallet public smartwallet;
    AuthorizationRegistry public registry;

    address internal constant ley = address(11);
    address internal constant nava = address(22);
    address internal constant bob = address(33);

    function setUp() public {
        vm.deal(ley, 20 ether);
        vm.prank(ley);
        registry = new AuthorizationRegistry();
        smartwallet = new SmartWallet(ley, registry, ley);
    }

    function testOwner() public {
        address owner = smartwallet.owner();
        assertEq(owner, ley);
    }

    function testFailOwner() public {
        address owner = smartwallet.owner();
        assertEq(owner, nava);
    }

    function testCreateSubWallet() public {
        DataTypes.SubwalletParams memory params;
        params.target = nava;
        vm.prank(ley);
        ISubWallet newSubwallet = smartwallet.createSubwallet{value: 4}(params);
        assertEq(address(newSubwallet.parentWallet()), address(smartwallet));
        assertEq(newSubwallet.target(), nava);
        assertEq(address(newSubwallet).balance, 4);
    }

    function testListSubwallets() public {
        DataTypes.SubwalletParams memory params;
        params.target = nava;
        vm.prank(ley);
        ISubWallet firstSubwallet = smartwallet.createSubwallet{value: 4 ether}(
            params
        );

        params.target = bob;
        vm.prank(ley);
        ISubWallet secondSubwallet = smartwallet.createSubwallet{
            value: 4 ether
        }(params);

        assertEq(smartwallet.listSubwallets().length, 2);
        assertEq(firstSubwallet.target(), nava);
        assertEq(secondSubwallet.target(), bob);
    }
}
