// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IReviewModule {
    function init(uint256 bountyId, bytes calldata data)
        external
        returns (bytes memory);

    function processFulfill(uint256 bountyId, bytes calldata data)
        external
        returns (bytes memory);
}
