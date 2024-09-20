const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Voting Contract", function () {
  let Voting, voting, owner, voter1, voter2;

  beforeEach(async function () {
    // Get the contract factory and signers
    Voting = await ethers.getContractFactory("Voting");
    [owner, voter1, voter2] = await ethers.getSigners();

    // Deploy the contract
    voting = await Voting.deploy();
    await voting.deployed();
  });

  it("Should deploy the contract and set the owner", async function () {
    expect(await voting.admin()).to.equal(owner.address);
  });

  it("Should allow the admin to add candidates", async function () {
    await voting.addCandidate("Alice");
    await voting.addCandidate("Bob");
    const candidates = await voting.getCandidates();
    expect(candidates.length).to.equal(2);
    expect(candidates[0].name).to.equal("Alice");
    expect(candidates[1].name).to.equal("Bob");
  });

  it("Should register voters and allow them to vote", async function () {
    await voting.registerVoter(voter1.address);
    await voting.registerVoter(voter2.address);

    await voting.startVoting();

    await voting.connect(voter1).vote(0); // voter1 votes for Alice
    await voting.connect(voter2).vote(1); // voter2 votes for Bob

    const candidate1 = await voting.getCandidate(0);
    const candidate2 = await voting.getCandidate(1);
    expect(candidate1.voteCount).to.equal(1);
    expect(candidate2.voteCount).to.equal(1);
  });

  it("Should prevent double voting", async function () {
    await voting.registerVoter(voter1.address);
    await voting.startVoting();
    await voting.connect(voter1).vote(0);

    await expect(voting.connect(voter1).vote(0)).to.be.revertedWith("You have already voted.");
  });
});
