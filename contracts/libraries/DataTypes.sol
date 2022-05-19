// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library DataTypes {
    struct Bounty {
        address claimNFT;
        address claimModule;
        address reviewNFT;
        address reviewModule;
        string contentUri;
    }

    struct CreateBountyData {
        address claimModule;
        bytes claimModuleInitData;
        address reviewModule;
        bytes reviewModuleInitData;
        string contentUri;
    }
}
