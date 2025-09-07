// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    // The address of the person who deployed the contract (the election administrator)
    address public owner;

    // A struct to represent a candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // A mapping to store candidates by their ID
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;

    // Mappings to track voter status
    mapping(address => bool) public isVoterRegistered;
    mapping(address => bool) public hasVoted;

    // Event to announce when a new vote is cast
    event Voted(address indexed voter, uint indexed candidateId);

    // The constructor runs once when the contract is deployed
    constructor() {
        owner = msg.sender; // Set the contract creator as the owner
    }

    // Modifier to restrict a function to be called only by the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // Function to add a new candidate (only owner)
    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }



    // Function to register a new voter (only owner)
    function registerVoter(address _voterAddress) public onlyOwner {
        require(!isVoterRegistered[_voterAddress], "Voter is already registered.");
        isVoterRegistered[_voterAddress] = true;
    }

    // The main voting function
    function vote(uint _candidateId) public {
        // 1. Check if the voter is registered
        require(isVoterRegistered[msg.sender], "You are not a registered voter.");
        // 2. Check if the voter has already voted
        require(!hasVoted[msg.sender], "You have already cast your vote.");
        // 3. Check if the candidate is valid
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate ID.");

        // Record the vote
        candidates[_candidateId].voteCount++;
        hasVoted[msg.sender] = true;

        // Trigger the Voted event
        emit Voted(msg.sender, _candidateId);
    }

    // A "view" function to get all candidates (doesn't cost gas)
    function getAllCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory allCandidates = new Candidate[](candidatesCount);
        for (uint i = 1; i <= candidatesCount; i++) {
            allCandidates[i-1] = candidates[i];
        }
        return allCandidates;
    }
}