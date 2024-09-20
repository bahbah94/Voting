async function main() {
    // Get the contract factory
    const Voting = await ethers.getContractFactory("Voting");
    
    // Deploy the contract
    const voting = await Voting.deploy();
    await voting.deployed();
  
    console.log("Voting contract deployed to:", voting.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  