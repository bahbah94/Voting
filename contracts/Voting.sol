// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        string name;
        uint voteCount;
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint voteIndex;
    }

    address public admin;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    bool public votingOpen;

    event VoterRegistered(address voter);
    event CandidateAdded(string name);
    event VoteCast(address voter, uint candidateIndex);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function.");
        _;
    }

    modifier votingIsOpen() {
        require(votingOpen, "Voting is not open.");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addCandidate(string memory _name) public onlyAdmin {
        candidates.push(Candidate(_name, 0));
        emit CandidateAdded(_name);
    }

    function registerVoter(address _voter) public onlyAdmin {
        require(!voters[_voter].isRegistered, "Voter is already registered.");
        voters[_voter] = Voter(true, false, 0);
        emit VoterRegistered(_voter);
    }

    function startVoting() public onlyAdmin {
        votingOpen = true;
    }

    function stopVoting() public onlyAdmin {
        votingOpen = false;
    }

    function vote(uint _candidateIndex) public votingIsOpen {
        Voter storage sender = voters[msg.sender];
        require(sender.isRegistered, "You are not registered to vote.");
        require(!sender.hasVoted, "You have already voted.");
        require(_candidateIndex < candidates.length, "Invalid candidate index.");

        sender.hasVoted = true;
        sender.voteIndex = _candidateIndex;
        candidates[_candidateIndex].voteCount += 1;

        emit VoteCast(msg.sender, _candidateIndex);
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    function getCandidate(uint _index) public view returns (string memory, uint) {
        require(_index < candidates.length, "Invalid candidate index.");
        Candidate storage candidate = candidates[_index];
        return (candidate.name, candidate.voteCount);
    }
}
