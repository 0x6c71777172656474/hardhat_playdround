import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";
import "solidity-coverage";

const config: HardhatUserConfig = {
  networks: {
    goerli: {
      url: process.env.ALCHEMY_GOERLI,
      chainId: 5,
      accounts: [process.env.PRIVATE_KEY || ""],
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.8.9",
        settings: {
          optimizer: {
            enabled: true,
            runs: 1000,
          },
        },
      },
    ],
  },
  mocha: {
    timeout: 40000,
  },
  etherscan: {
    apiKey: {
      goerli: process.env.ETHERSCAN_API || "",
    },
  },
};

export default config;
