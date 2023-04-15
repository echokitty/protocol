// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IAuthorizationRegistry {
    event AuthorizationChanged(
        address indexed authorizer,
        address indexed authorized
    );

    /// @notice Authorizes msg.sender to execute trades on behalf of `msg.sender`
    /// @param authorized will typically be the address of a monitoring bot
    /// msg.sender will be typically the address of the smart wallet
    function authorize(address authorized) external;

    /// @return the address of the authorizer for the given account
    function authorizedFor(address account) external view returns (address);
}
