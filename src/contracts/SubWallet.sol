// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../libraries/Datatypes.sol";
import "../interfaces/ISubWallet.sol";


contract SubWallet is ISubWallet {
    address public owner;
    address public target;
    address[] public tokens;

    constructor(DataTypes.SubwalletParams memory params) payable {
        require(msg.value > 0, "Not enough eth.");
        owner = params.owner;
        target = params.target;
    }

    function listTokens() external view returns (address[] memory) {
        return tokens;
    }
}
