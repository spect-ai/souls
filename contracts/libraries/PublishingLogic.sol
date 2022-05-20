// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from "./DataTypes.sol";
import {Events} from "./Events.sol";
import {IReviewModule} from "../interfaces/IReviewModule.sol";
import {IClaimModule} from "../interfaces/IClaimModule.sol";
import {IClaimNFT} from "../interfaces/IClaimNFT.sol";
import {ClaimNFT} from "../core/ClaimNFT.sol";

library PublishingLogic {
    function createBounty(
        address issuer,
        DataTypes.CreateBountyData calldata vars,
        uint256 bountyId,
        mapping(uint256 => DataTypes.Bounty) storage _bountyIdToBounty
    ) external {
        _validateBountyData(vars);
        _bountyIdToBounty[bountyId].contentUri = vars.contentUri;

        if (vars.claimModule != address(0)) {
            bytes memory claimModuleReturnData = _initBountyClaimModule(
                vars.claimModule,
                vars.claimModuleInitData,
                bountyId,
                _bountyIdToBounty
            );
        }
        if (vars.reviewModule != address(0)) {
            bytes memory issueModuleReturnData = _initBountyReviewModule(
                vars.reviewModule,
                vars.reviewModuleInitData,
                bountyId,
                _bountyIdToBounty
            );
        }
        emit Events.BountyCreated(
            bountyId,
            issuer,
            address(0),
            vars.claimModule,
            address(0),
            vars.reviewModule,
            vars.contentUri
        );
    }

    function _initBountyClaimModule(
        address claimModule,
        bytes memory claimModuleInitData,
        uint256 bountyId,
        mapping(uint256 => DataTypes.Bounty) storage _bountyIdToBounty
    ) internal returns (bytes memory) {
        _bountyIdToBounty[bountyId].claimModule = claimModule;
        return IClaimModule(claimModule).init(bountyId, claimModuleInitData);
    }

    function _initBountyReviewModule(
        address reviewModule,
        bytes memory reviewModuleInitData,
        uint256 bountyId,
        mapping(uint256 => DataTypes.Bounty) storage _bountyIdToBounty
    ) internal returns (bytes memory) {
        _bountyIdToBounty[bountyId].reviewModule = reviewModule;
        return IReviewModule(reviewModule).init(bountyId, reviewModuleInitData);
    }

    function claim(
        uint256 bountyId,
        address claimee,
        address hub,
        mapping(uint256 => DataTypes.Bounty) storage _bountyIdToBounty
    ) external returns (uint256) {
        uint256 tokenId;
        address claimModule = _bountyIdToBounty[bountyId].claimModule;
        address claimNFT = _bountyIdToBounty[bountyId].claimNFT;
        if (claimNFT == address(0)) {
            claimNFT = address(new ClaimNFT(hub));
            _bountyIdToBounty[bountyId].claimNFT = claimNFT;
        }
        tokenId = IClaimNFT(claimNFT).mint(claimee);

        IClaimModule(claimModule).processClaim(bountyId, claimee, bytes(""));
        emit Events.BountyClaimed(bountyId, claimee, claimNFT, tokenId);
        return tokenId;
    }

    function review() external {}

    function _validateBountyData(DataTypes.CreateBountyData calldata vars)
        internal
    {
        return;
    }
}
