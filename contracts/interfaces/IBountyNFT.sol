// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBountyNFT {
    function initialize(
        uint256 bountyId,
        string calldata name,
        string calldata symbol
    ) external;

    function mint(address to) external returns (uint256);

    function getSourceBountyPointer() external view returns (uint256);
}
