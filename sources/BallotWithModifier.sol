// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title BallotWithStages
 * @dev Ballot for voting with stages and modifiers
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Ballot {

    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
        //address delegate;
    }
    struct Proposal {
        uint voteCount;
    }
    enum Stage {Init,Reg, Vote, Done}
    Stage public stage = Stage.Init;
    
    address chairperson;
    mapping(address => Voter) voters;
    Proposal[] proposals;

    event votingCompleted();
    
    uint startTime;
    //modifiers
    modifier validStage(Stage reqStage)
    { require(stage == reqStage);
      _;
    }


    /// Create a new ballot with $(_numProposals) different proposals.
    /**
     * @dev Constructor of the Ballot
     * @param _numProposals number of the different proposals
     */
    constructor(uint8 _numProposals)  {
        chairperson = msg.sender;
        voters[chairperson].weight = 2; // weight is 2 for testing purposes
        for (uint i = 0; i < _numProposals; i++) {
            proposals.push(Proposal({
                voteCount: 0
            }));
        }
        stage = Stage.Reg;
        startTime = block.timestamp;
    }

    /// Give $(toVoter) the right to vote on this ballot.
    /// May only be called by $(chairperson).
    /**
     * @dev Register the voter by the chairperson
     * @param toVoter address of the voter to be registered
     */
    function register(address toVoter) public validStage(Stage.Reg) {
        //if (stage != Stage.Reg) {return;}
        if (msg.sender != chairperson || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;
        voters[toVoter].voted = false;
        if (block.timestamp > (startTime+ 10 seconds)) {stage = Stage.Vote; }        
    }

    /// Give a single vote to proposal $(toProposal).
    /**
     * @dev Vote one time for each voter
     * @param toProposal the number of the proposal to be voted
     */
    function vote(uint8 toProposal) public validStage(Stage.Vote)  {
       // if (stage != Stage.Vote) {return;}
        Voter storage sender = voters[msg.sender];
        if (sender.voted || toProposal >= proposals.length) return;
        sender.voted = true;
        sender.vote = toProposal;   
        proposals[toProposal].voteCount += sender.weight;
        if (block.timestamp > (startTime+ 10 seconds)) {stage = Stage.Done; emit votingCompleted();}              
    }

    /**
     * @dev Compute the proposal which wins the vote
     * @return _winningProposal the winning vote!
     */
    function winningProposal() public validStage(Stage.Done) view returns (uint8 _winningProposal) {
       //if(stage != Stage.Done) {return;}
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < proposals.length; prop++)
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
       assert (winningVoteCount > 0);
    }
}