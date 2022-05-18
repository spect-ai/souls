//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from "../libraries/DataTypes.sol";

abstract contract CredsStorage {
    uint256 internal bountyCounter;
    mapping(uint256 => DataTypes.Bounty) internal _bountyIdToBounty;
}
