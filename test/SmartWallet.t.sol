// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/contracts/SmartWallet.sol";
import "../src/interfaces/ISubWallet.sol";
import "../src/libraries/Datatypes.sol";

contract SmartWalletTest is Test {
    SmartWallet public smartwallet;
    address internal constant ley = address(11);
    address internal constant nava = address(22);
    address internal constant bob = address(33);

    function setUp() public {
        vm.deal(ley, 20 ether);
        vm.prank(ley);
        // smartwallet = new SmartWallet();
        smartwallet = (new SmartWallet){value: 10}();
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
        // create a SubwalletParams manually here? Will in reality be called from the FE?
        DataTypes.SubwalletParams memory params;
        params.owner = ley;
        params.target = nava;
        params.amount = 4;
        ISubWallet newSubwallet = smartwallet.createSubwallet((params));
        assertEq(newSubwallet.owner(), ley);
        assertEq(newSubwallet.target(), nava);
        assertEq(address(newSubwallet).balance, 4);
    }

    function testListSubwallets() public {
        DataTypes.SubwalletParams memory params;
        params.owner = ley;
        params.target = nava;
        params.amount = 4;
        ISubWallet firstSubwallet = smartwallet.createSubwallet((params));

        params.target = bob;
        ISubWallet secondSubwallet = smartwallet.createSubwallet((params));

        assertEq(smartwallet.listSubwallets().length, 2);
        assertEq(firstSubwallet.target(), nava);
        assertEq(secondSubwallet.target(), bob);
    }

    function testValueReceived() public {
        assertEq(address(smartwallet).balance, 10);
    }

    function testFailNoValueReceived() public {
        (new SmartWallet){value: 0}();
    }
}
