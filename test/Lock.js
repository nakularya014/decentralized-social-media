require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
    },
    coreTestnet2: {
      url: "https://rpc.test2.btcs.network",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 1115,
      gasPrice: 20000000000, // 20 gwei
    },
  },
  etherscan: {
    // Add API key if you want to verify contracts
    apiKey: {
      coreTestnet2: process.env.CORE_SCAN_API_KEY || "your-api-key-here"
    }
  },
};
