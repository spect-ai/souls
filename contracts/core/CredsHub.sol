//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./CredsStorage.sol";
import {DataTypes} from "../libraries/DataTypes.sol";
import {PublishingLogic} from "../libraries/PublishingLogic.sol";
import {ICredsHub} from "../interfaces/ICredsHub.sol";

contract CredsHub is CredsStorage, ICredsHub {
    constructor() {}

    function createBounty(DataTypes.CreateBountyData calldata vars)
        public
        returns (uint256)
    {
        unchecked {
            uint256 bountyId = ++bountyCounter;
            PublishingLogic.createBounty(vars, bountyId, _bountyIdToBounty);
            return bountyId;
        }
    }

    function claimBounty(uint256 bountyId) public returns (uint256) {
        unchecked {
            PublishingLogic.claim(
                bountyId,
                msg.sender,
                address(this),
                _bountyIdToBounty
            );
            return bountyId;
        }
    }

    function getContentURI(uint256 bountyId)
        public
        view
        override
        returns (string memory)
    {
        return _bountyIdToBounty[bountyId].contentUri;
    }
}
