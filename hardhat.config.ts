import * as dotenv from "dotenv";

// eslint-disable-next-line node/no-extraneous-import
import glob from "glob";
import path from "path";
import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
dotenv.config();

if (!process.env.SKIP_LOAD) {
  glob.sync("./tasks/**/*.ts").forEach(function (file) {
    require(path.resolve(file));
  });
}
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: "0.8.4",
  networks: {
    ropsten: {
      url: process.env.ROPSTEN_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
    dev: {
      url: "http://127.0.0.1:8545",
      chainId: 31337,
      gas: 12000000,
      blockGasLimit: 0x1fffffffffffff,
      allowUnlimitedContractSize: true,
      timeout: 1800000,
    },
    mumbai: {
      url: "https://speedy-nodes-nyc.moralis.io/27686f41b7c9afc73b87dfa2/polygon/mumbai",
      chainId: 80001,
      accounts: {
        mnemonic: "test test test test test test test test test test test junk",
      },
    },
    polygon: {
      url: "https://speedy-nodes-nyc.moralis.io/f84f46508f22a737cbbdb355/polygon/mainnet",
      chainId: 137,
      accounts: {
        mnemonic: "secret",
      },
    },
    metis: {
      url: "https://andromeda.metis.io/?owner=1088",
      chainId: 1088,
      accounts: {
        mnemonic: "secret",
      },
    },
    boba: {
      url: "https://mainnet.boba.network",
      chainId: 288,
      accounts: {
        mnemonic: "secret",
      },
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;
