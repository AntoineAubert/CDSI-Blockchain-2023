// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Ballot
 * @dev Ballot for voting
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Ballot {

    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
    }
    struct Proposal {
        uint voteCount;
    }

    address chairperson;
    mapping(address => Voter) voters;
    Proposal[] proposals;
    

    /// Create a new ballot with $(_numProposals) different proposals.
    /**
     * @dev Constructor of the Ballot
     * @param _numProposals number of the different proposals
     */
    constructor(uint8 _numProposals) {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;

        // For each of the provided proposal,
        // create a new proposal object and add it
        // to the end of the array.
        for (uint i = 0; i < _numProposals; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            proposals.push(Proposal({
                voteCount: 0
            }));
        }
    }

    /// Give $(toVoter) the right to vote on this ballot.
    /// May only be called by $(chairperson).
    /**
     * @dev Register the voter by the chairperson
     * @param toVoter address of the voter to be registered
     */
    function register(address toVoter) public {
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
    }

    /// Give a single vote to proposal $(toProposal).
    /**
     * @dev Vote one time for each voter
     * @param toProposal the number of the proposal to be voted
     */
    function vote(uint8 toProposal) public {
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }

    /**
     * @dev Compute the proposal which wins the vote
     * @return _winningProposal the winning vote!
     */
    function winningProposal() public view returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }
}