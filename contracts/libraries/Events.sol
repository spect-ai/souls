// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from "./DataTypes.sol";

library Events {
    event BountyCreated(
        uint256 bountyId,
        address claimNFT,
        address claimModule,
        address issueNFT,
        address issueModule,
        string contentUri
    );
}
