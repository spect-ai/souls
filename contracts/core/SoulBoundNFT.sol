// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ICredsHub} from "../interfaces/ICredsHub.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

error AlreadeInitialized();
error TokenDoesNotExist();
error InitParamsInvalid();

abstract contract SoulBoundNFT is ERC721 {
    address public immutable HUB;

    uint256 internal _bountyId;
    uint256 internal _tokenIdCounter;

    bool private _initialized;

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
    ) external {
        if (_initialized) revert AlreadeInitialized();
        _initialized = true;
        _bountyId = bountyId;

        //emit Events.CollectNFTInitialized(profileId, pubId, block.timestamp);
    }

    function mint(address to) external returns (uint256) {
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
        return ICredsHub(HUB).getContentURI(_bountyId);
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
