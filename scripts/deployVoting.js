async function main() {
  // Get the contract factory
  const Voting = await ethers.getContractFactory("Voting");

  // Deploy the contract
  const votingContract = await Voting.deploy();
  await votingContract.waitForDeployment();

  // Log the contract address
  console.log("Voting contract deployed to:", await votingContract.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });