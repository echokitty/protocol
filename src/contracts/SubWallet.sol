// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import "../libraries/Datatypes.sol";
import "../interfaces/ISubWallet.sol";
import "../interfaces/IAuthorizationRegistry.sol";
import "../interfaces/ISmartWallet.sol";

contract SubWallet is ISubWallet, Initializable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using Address for address;
    using Address for address payable;

    uint256 public immutable createdAt;
    ISmartWallet public immutable parentWallet;
    address public immutable target;
    uint256 public immutable initialValue;

    EnumerableSet.AddressSet internal _tokens;

    constructor(address _target) payable {
        require(msg.value > 0, "Not enough eth.");
        createdAt = block.timestamp;
        parentWallet = ISmartWallet(msg.sender);
        target = _target;
        initialValue = msg.value;
    }

    function initializeWallet(
        DataTypes.RawSwap[] memory swaps
    ) external initializer {
        require(
            msg.sender == address(parentWallet),
            "not authorized to initialize"
        );
        _executeSwaps(swaps);
    }

    function listTokens() external view returns (address[] memory) {
        return _tokens.values();
    }

    function executeSwap(DataTypes.RawSwap memory swap) external override {
        require(
            parentWallet.isAuthorized(msg.sender),
            "not authorized to swap"
        );
        _executeSwap(swap);
    }

    function tearDown(DataTypes.RawSwap[] memory swaps) external {
        require(
            msg.sender == address(parentWallet),
            "not authorized to tear down"
        );
        _executeSwaps(swaps);
        payable(address(parentWallet)).sendValue(address(this).balance);
    }

    function _executeSwaps(DataTypes.RawSwap[] memory swaps) internal {
        for (uint256 i = 0; i < swaps.length; i++) {
            _executeSwap(swaps[i]);
        }
    }

    function _executeSwap(DataTypes.RawSwap memory swap) internal {
        swap.call.target.functionCallWithValue(
            swap.call.data,
            swap.call.value,
            "swap failed"
        );
        _tokens.add(swap.outputToken);
    }
}
