// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from "./DataTypes.sol";

library Events {
    event BountyCreated(
        uint256 bountyId,
        address issuer,
        address claimNFT,
        address claimModule,
        address reviewNFT,
        address reviewModule,
        string contentUri
    );

    event BountyClaimed(
        uint256 bountyId,
        address claimedBy,
        address claimedNFT,
        uint256 tokenId
    );

    event BountySubmitted(uint256 bountyId, address submittedBy);

    event BountyReviewed(
        uint256 bountyId,
        address reviewedBy,
        address reviewNFT,
        uint256 tokenId
    );

    event BountyFulfilled(uint256 bountyId, address fulfilledBy);
}
