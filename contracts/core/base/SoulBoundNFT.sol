// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ICredsHub} from "../../interfaces/ICredsHub.sol";
import {ERC721Time} from "./ERC721Time.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

error AlreadyInitialized();
error TokenDoesNotExist();
error InitParamsInvalid();
error TokenBoundToSoul();

abstract contract SoulBoundNFT is ERC721Time {
    address private immutable HUB;

    uint256 internal _tokenIdCounter;

    bool internal _initialized;
    mapping(uint256 => bool) locked;

    // We create the CollectNFT with the pre-computed HUB address before deploying the hub proxy in order
    // to initialize the hub proxy at construction.
    constructor(address hub) {
        if (hub == address(0)) revert InitParamsInvalid();
        HUB = hub;
        _initialized = true;
    }

    function initialize(
        uint256 bountyId,
        string calldata name,
        string calldata symbol
    ) public virtual {
        if (_initialized) revert AlreadyInitialized();
        _initialized = true;
        ERC721Time.__ERC721_Init(name, symbol);
    }

    function mint(address to) external virtual returns (uint256) {
        unchecked {
            uint256 tokenId = ++_tokenIdCounter;
            locked[tokenId] = true;
            _mint(to, tokenId);
            return tokenId;
        }
    }

    /**
     * @dev Upon transfers, we emit the transfer event in the hub.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        if (locked[tokenId] == true) revert TokenBoundToSoul();
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
