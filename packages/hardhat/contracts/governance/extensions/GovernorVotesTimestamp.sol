// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (governance/extensions/GovernorVotes.sol)

pragma solidity ^0.8.0;

import "../Governor.sol";
import "../utils/IVotesTimestamp.sol";

/**
 * @dev Extension of {Governor} for voting weight extraction from an {ERC20Votes} token, or since v4.5 an {ERC721Votes} token.
 *
 * _Available since v4.3._
 */
abstract contract GovernorVotesTimestamp is Governor {
    IVotesTimestamp public immutable token;

    constructor(IVotesTimestamp tokenAddress) {
        token = tokenAddress;
    }

    /**
     * Read the voting weight from the token's built in snapshot mechanism (see {IGovernor-getLinearlyDecayedVotes}).
     */
    function getLinearlyDecayedVotes(address account, uint256 timestamp) public view virtual override returns (uint256) {
        uint256 percentOfTimeElapsed = ((block.timestamp - voteStart()) * 100) / votingPeriod(); // Get (rounded to the lowest percent) the percentile of linear decay the contest is at currently
        return (percentOfTimeElapsed * token.getPastVotes(account, timestamp)) / 100;
    }

    /**
     * Read the voting weight from the token's built in snapshot mechanism (see {IGovernor-getVotes}).
     */
    function getVotes(address account, uint256 timestamp) public view virtual override returns (uint256) {
        return token.getPastVotes(account, timestamp);
    }

    /**
     * Read the voting weight from the token's built in snapshot mechanism (see {IGovernor-getCurrentVotes}).
     */
    function getCurrentVotes(address account) public view virtual override returns (uint256) {
        return token.getVotes(account);
    }
}
