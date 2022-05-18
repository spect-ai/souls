// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICredsHub {
    function getContentURI(uint256 bountyId)
        external
        view
        returns (string memory);
}
