//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from "../../libraries/DataTypes.sol";
import {IReviewModule} from "../../interfaces/IReviewModule.sol";

abstract contract ReviewModule is IReviewModule {
    function init() external returns (bytes memory) {
        return new bytes(0);
    }

    function processFulfill(uint256 bountyId, bytes calldata data)
        external
        returns (bytes memory)
    {
        return new bytes(0);
    }
}
