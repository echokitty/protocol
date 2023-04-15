// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "../interfaces/IAuthorizationRegistry.sol";

contract AuthorizationRegistry is IAuthorizationRegistry {
    using EnumerableSet for EnumerableSet.AddressSet;

    mapping(address => address) internal _authorizations;
    mapping(address => EnumerableSet.AddressSet) internal _managedBy;

    function authorize(address authorized) external override {
        _managedBy[_authorizations[msg.sender]].remove(msg.sender);
        _authorizations[msg.sender] = authorized;
        _managedBy[authorized].add(msg.sender);
        emit AuthorizationChanged(msg.sender, authorized);
    }

    function authorizedFor(address account) external view returns (address) {
        return _authorizations[account];
    }

    function isAuthorized(
        address account,
        address manager
    ) external view returns (bool) {
        return _authorizations[account] == manager;
    }

    function addressesManagedBy(
        address manager
    ) external view returns (address[] memory) {
        return _managedBy[manager].values();
    }
}
