import { ethers } from "hardhat";
import fs from "fs";

async function main() {
  const PublishingLogic = await ethers.getContractFactory("PublishingLogic");
  const publishingLogic = await PublishingLogic.deploy();

  await publishingLogic.deployed();

  const hubLibs = {
    "contracts/libraries/PublishingLogic.sol:PublishingLogic":
      publishingLogic.address,
  };

  const CredsHub = await ethers.getContractFactory("CredsHub", {
    libraries: hubLibs,
  });
  const credsHub = await CredsHub.deploy();

  await credsHub.deployed();

  const ClaimModule = await ethers.getContractFactory("ClaimModule");
  const claimModule = await ClaimModule.deploy();

  await claimModule.deployed();

  // const ReviewModule = await ethers.getContractFactory("ReviewModule");
  // const reviewModule = await ReviewModule.deploy();

  // await reviewModule.deployed();

  const addrs = {
    credHub: credsHub.address,
    claimModule: claimModule.address,
    publishingLogic: publishingLogic.address,
  };
  const json = JSON.stringify(addrs, null, 2);
  console.log(json);
  fs.writeFileSync("addresses.json", json, "utf-8");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
