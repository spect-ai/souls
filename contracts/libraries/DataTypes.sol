// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library DataTypes {
    struct Bounty {
        address bountyNFT;
        address claimModule;
        string contentUri;
    }

    struct CreateBountyData {
        address claimModule;
        bytes claimModuleInitData;
        string contentUri;
    }
}
