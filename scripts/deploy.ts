import { ethers } from "hardhat";
import fs from "fs";

async function main() {
  const BountyLogic = await ethers.getContractFactory("BountyLogic");
  const logic = await BountyLogic.deploy();

  await logic.deployed();

  const hubLibs = {
    "contracts/libraries/BountyLogic.sol:BountyLogic": logic.address,
  };

  const CredsHub = await ethers.getContractFactory("CredsHub", {
    libraries: hubLibs,
  });
  const credsHub = await CredsHub.deploy();

  await credsHub.deployed();

  const ClaimModule = await ethers.getContractFactory("ClaimModule");
  const claimModule = await ClaimModule.deploy();

  await claimModule.deployed();

  const addrs = {
    credHub: credsHub.address,
    claimModule: claimModule.address,
    publishingLogic: logic.address,
  };
  const json = JSON.stringify(addrs, null, 2);
  console.log(json);
  fs.writeFileSync("addresses.json", json, "utf-8");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
