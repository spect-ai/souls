// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from "./DataTypes.sol";
import {Events} from "./Events.sol";
import {IClaimModule} from "../interfaces/IClaimModule.sol";
import {IBountyNFT} from "../interfaces/IBountyNFT.sol";
import {BountyNFT} from "../core/BountyNFT.sol";

library BountyLogic {
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
        emit Events.BountyCreated(
            bountyId,
            issuer,
            address(0),
            vars.claimModule,
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

    function claim(
        uint256 bountyId,
        address claimee,
        address hub,
        mapping(uint256 => DataTypes.Bounty) storage _bountyIdToBounty
    ) external returns (uint256) {
        uint256 tokenId;
        address claimModule = _bountyIdToBounty[bountyId].claimModule;
        address bountyNFT = _bountyIdToBounty[bountyId].bountyNFT;
        if (bountyNFT == address(0)) {
            bountyNFT = address(new BountyNFT(hub));
            _bountyIdToBounty[bountyId].bountyNFT = bountyNFT;
        }
        tokenId = IBountyNFT(bountyNFT).mint(claimee);

        IClaimModule(claimModule).processClaim(bountyId, claimee, bytes(""));
        emit Events.BountyClaimed(bountyId, claimee, bountyNFT, tokenId);
        return tokenId;
    }

    function _validateBountyData(DataTypes.CreateBountyData calldata vars)
        internal
    {
        return;
    }
}
