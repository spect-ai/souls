// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SoulBoundNFT} from "./base/SoulBoundNFT.sol";
import {ICredsHub} from "../interfaces/ICredsHub.sol";

error AlreadyInitialized();
error TokenDoesNotExist();
error InitParamsInvalid();

contract BountyNFT is SoulBoundNFT {
    uint256 internal _bountyId;

    // We create the CollectNFT with the pre-computed HUB address before deploying the hub proxy in order
    // to initialize the hub proxy at construction.
    constructor(address hub) SoulBoundNFT(hub) {}

    function initialize(
        uint256 bountyId,
        string calldata name,
        string calldata symbol
    ) public override {
        if (_initialized) revert AlreadyInitialized();
        _initialized = true;
        _bountyId = bountyId;
    }

    function mint(address to) external override returns (uint256) {
        unchecked {
            uint256 tokenId = ++_tokenIdCounter;
            _mint(to, tokenId);
            return tokenId;
        }
    }

    function getSourceBountyPointer() external view returns (uint256) {
        return _bountyId;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        if (!_exists(tokenId)) revert TokenDoesNotExist();
        return super.tokenURI(tokenId);
    }

    /**
     * @dev Upon transfers, we emit the transfer event in the hub.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
