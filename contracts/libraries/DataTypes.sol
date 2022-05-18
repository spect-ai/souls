// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library DataTypes {
    struct Bounty {
        address claimNFT;
        address claimModule;
        address issueNFT;
        address issueModule;
        string contentUri;
    }

    struct CreateBountyData {
        address claimModule;
        bytes claimModuleInitData;
        address issueModule;
        bytes issueModuleInitData;
        string contentUri;
    }
}
