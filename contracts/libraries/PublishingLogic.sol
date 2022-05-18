// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from "./DataTypes.sol";
import {IReviewModule} from "../interfaces/IIssueModule.sol";
import {IClaimModule} from "../interfaces/IClaimModule.sol";

library PublishingLogic {
    function createBounty(
        DataTypes.CreateBountyData calldata vars,
        uint256 bountyId,
        mapping(uint256 => DataTypes.Bounty) storage _bountyIdToBounty
    ) external {
        _validateBountyData(vars);
        _bountyIdToBounty[bountyId].contentUri = vars.contentUri;

        bytes memory issueModuleReturnData = _initBountyReviewModule(
            vars.issueModule,
            vars.issueModuleInitData,
            bountyId,
            _bountyIdToBounty
        );

        bytes memory claimModuleReturnData = _initBountyClaimModule(
            vars.claimModule,
            vars.claimModuleInitData,
            bountyId,
            _bountyIdToBounty
        );
    }

    function _initBountyReviewModule(
        address issueModule,
        bytes memory issueModuleInitData,
        uint256 bountyId,
        mapping(uint256 => DataTypes.Bounty) storage _bountyIdToBounty
    ) internal returns (bytes memory) {
        _bountyIdToBounty[bountyId].issueModule = issueModule;
        return IReviewModule(issueModule).init(bountyId, issueModuleInitData);
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

    function _validateBountyData(DataTypes.CreateBountyData calldata vars)
        internal
    {
        return;
    }
}
