// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../libraries/Datatypes.sol";
import "../interfaces/ISmartWallet.sol";
import "./SubWallet.sol";

contract SmartWallet is ISmartWallet {
    address public owner;
    ISubWallet[] public subwallets;

    constructor() payable {
        require(msg.value > 0, "Value must be over 0");
        owner = msg.sender;
    }

    function createSubwallet(
        DataTypes.SubwalletParams calldata params
    ) external returns (ISubWallet) {
        SubWallet subwallet = (new SubWallet){value: params.amount}(params);
        subwallets.push(ISubWallet(address(subwallet)));
        return ISubWallet(address(subwallet));
    }

    function listSubwallets() external view returns (ISubWallet[] memory) {
        return subwallets;
    }
}
