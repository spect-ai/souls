//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DataTypes} from "../../libraries/DataTypes.sol";
import {IClaimModule} from "../../interfaces/IClaimModule.sol";

error AddressNotWhitelisted();

contract ClaimModule {
    mapping(uint256 => mapping(address => bool)) whitelist;

    function init(uint256 bountyId, bytes calldata data)
        external
        returns (bytes memory)
    {
        address whitelistedAddress = abi.decode(data, (address));
        whitelist[bountyId][whitelistedAddress] = true;
    }

    function processClaim(
        uint256 bountyId,
        address claimee,
        bytes calldata data
    ) external {
        if (whitelist[bountyId][claimee] == false)
            revert AddressNotWhitelisted();
    }

    function isWhitelistedAddress(uint256 bountyId, address person)
        public
        view
        returns (bool)
    {
        return whitelist[bountyId][person];
    }

    function processSubmit(uint256 bountyId, bytes calldata data) external {}
}
