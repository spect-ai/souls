// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IClaimModule {
    function init(uint256 bountyId, bytes calldata data)
        external
        returns (bytes memory);

    function processClaim(uint256 bountyId, bytes calldata data) external;

    function processSubmit(uint256 bountyId, bytes calldata data) external;
}
