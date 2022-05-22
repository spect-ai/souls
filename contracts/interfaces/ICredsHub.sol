// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICredsHub {
    function getContentURI(uint256 bountyId)
        external
        view
        returns (string memory);

    function getClaimModule(uint256 bountyId) external view returns (address);

    function getBountyNFT(uint256 bountyId) external view returns (address);
}
