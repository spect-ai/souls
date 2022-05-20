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
        console.log("creating bounty", vars.contentUri);
        unchecked {
            uint256 bountyId = ++bountyCounter;
            PublishingLogic.createBounty(
                msg.sender,
                vars,
                bountyId,
                _bountyIdToBounty
            );
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

    /* VIEW FUNCTIONS */

    function getNumBounties() public view returns (uint256) {
        console.log("bountyCounter", bountyCounter);

        return bountyCounter;
    }

    function getContentURI(uint256 bountyId)
        public
        view
        override
        returns (string memory)
    {
        return _bountyIdToBounty[bountyId].contentUri;
    }

    function getClaimModule(uint256 bountyId)
        public
        view
        override
        returns (address)
    {
        return _bountyIdToBounty[bountyId].claimModule;
    }

    function getClaimNFT(uint256 bountyId)
        public
        view
        override
        returns (address)
    {
        return _bountyIdToBounty[bountyId].claimNFT;
    }

    function getReviewModule(uint256 bountyId)
        public
        view
        override
        returns (address)
    {
        return _bountyIdToBounty[bountyId].reviewModule;
    }

    function getReviewNFT(uint256 bountyId)
        public
        view
        override
        returns (address)
    {
        return _bountyIdToBounty[bountyId].reviewNFT;
    }

    function getBounty(uint256 bountyId)
        public
        view
        returns (DataTypes.Bounty memory)
    {
        return _bountyIdToBounty[bountyId];
    }
}
