const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying Decentralized Social Media contract...");

  // Get the ContractFactory and Signers here
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Get account balance before deployment
  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", ethers.formatEther(balance), "CORE");

  // Deploy the contract
  const Project = await ethers.getContractFactory("Project");
  const project = await Project.deploy();

  // Wait for deployment to be mined
  await project.waitForDeployment();

  const contractAddress = await project.getAddress();
  console.log("Project contract deployed to:", contractAddress);

  // Verify deployment
  console.log("Verifying deployment...");
  const totalUsers = await project.getTotalUsers();
  const totalPosts = await project.getTotalPosts();
  
  console.log("Initial total users:", totalUsers.toString());
  console.log("Initial total posts:", totalPosts.toString());
  
  console.log("\n=== Deployment Summary ===");
  console.log("Contract Name: Project (Decentralized Social Media)");
  console.log("Contract Address:", contractAddress);
  console.log("Network: Core Testnet 2");
  console.log("Deployer:", deployer.address);
  console.log("Gas Used: Check transaction hash on Core Testnet 2 explorer");
  
  // Save deployment info
  const deploymentInfo = {
    contractName: "Project",
    contractAddress: contractAddress,
    network: "Core Testnet 2",
    deployer: deployer.address,
    deploymentTime: new Date().toISOString(),
    blockNumber: await ethers.provider.getBlockNumber()
  };
  
  console.log("\nDeployment completed successfully!");
  console.log("You can interact with the contract using the address:", contractAddress);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
