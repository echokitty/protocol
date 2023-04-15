// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

import "../libraries/Datatypes.sol";
import "../interfaces/ISmartWallet.sol";
import "../interfaces/IAuthorizationRegistry.sol";
import "./SubWallet.sol";

contract SmartWallet is ISmartWallet {
    using EnumerableSet for EnumerableSet.AddressSet;

    address public owner;
    IAuthorizationRegistry public immutable authorizationRegistry;
    EnumerableSet.AddressSet internal _subwallets;

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
        _subwallets.add(address(subwallet));
        emit SubwalletCreated(address(subwallet), msg.sender);
        return subwallet;
    }

    function shutdownSubwallet(
        address subwallet,
        DataTypes.RawSwap[] calldata swaps
    ) external onlyOwner {
        require(
            _subwallets.contains(subwallet),
            "Subwallet does not exist for this wallet"
        );
        ISubWallet(subwallet).tearDown(swaps);
        _subwallets.remove(subwallet);
        emit SubwalletShutdown(subwallet);
    }

    function isAuthorized(address manager) external view returns (bool) {
        return authorizationRegistry.isAuthorized(address(this), manager);
    }

    function changeManager(address newManager) external onlyOwner {
        authorizationRegistry.authorize(newManager);
    }

    function listSubwallets() external view returns (address[] memory) {
        return _subwallets.values();
    }
}
