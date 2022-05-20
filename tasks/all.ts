// eslint-disable-next-line node/no-unpublished-import
import "@nomiclabs/hardhat-ethers";
// eslint-disable-next-line node/no-unpublished-import
import { task } from "hardhat/config";
// eslint-disable-next-line node/no-missing-import
import { getAddrs, ZERO_ADDRESS } from "./utils";
import { abi as hubAbi } from "../info/CredsHub.json";
import { abi as claimAbi } from "../info/ClaimModule.json";

// eslint-disable-next-line no-empty-pattern
task("createBounty", "creates a bounty").setAction(async ({}, hre) => {
  const ethers = hre.ethers;
  const accounts = await ethers.getSigners();
  const issuer = accounts[0];
  const whitelistedClaimee = accounts[1];
  const addrs = getAddrs();
  const hub = new ethers.Contract(addrs.credHub, hubAbi, issuer);
  const inputStruct = {
    claimModule: addrs.claimModule,
    claimModuleInitData: ethers.utils.defaultAbiCoder.encode(
      ["address"],
      [whitelistedClaimee.address]
    ),
    reviewModule: ZERO_ADDRESS,
    reviewModuleInitData: ethers.utils.defaultAbiCoder.encode(
      ["address"],
      [""]
    ),
    contentUri: "popo",
  };
  const bounty = await hub.connect(issuer).createBounty(inputStruct);
  await bounty.wait();

  const numBounties = await hub.getNumBounties();
  console.log(numBounties);
});

task("claimBounty", "claim a bounty")
  .addParam("bountyid")
  .setAction(async ({ bountyid }, hre) => {
    const ethers = hre.ethers;
    const accounts = await ethers.getSigners();
    const whitelistedClaimee = accounts[1];
    const nonWhitelistedClaimee = accounts[2];

    const addrs = getAddrs();
    const hub = new ethers.Contract(addrs.credHub, hubAbi, whitelistedClaimee);
    const res = await hub.connect(whitelistedClaimee).claimBounty(bountyid);
    console.log(res);

    //const res2 = await hub.connect(nonWhitelistedClaimee).claimBounty(bountyid);
  });

task("getBounty", "gets a bounty")
  .addParam("bountyid")
  .setAction(async ({ bountyid }, hre) => {
    const ethers = hre.ethers;
    const accounts = await ethers.getSigners();
    const issuer = accounts[0];
    const addrs = getAddrs();
    const hub = new ethers.Contract(addrs.credHub, hubAbi, issuer);
    const bounty = await hub.getBounty(parseInt(bountyid));
    console.log(bounty);
  });

task("isWhitelistedClaimee", "gets if someone is whitelisted")
  .addParam("bountyid")
  .setAction(async ({ bountyid }, hre) => {
    const ethers = hre.ethers;
    const accounts = await ethers.getSigners();
    const whitelisted = accounts[1];
    const addrs = getAddrs();
    const claimModule = new ethers.Contract(
      addrs.claimModule,
      claimAbi,
      whitelisted
    );
    const isWhitelisted = await claimModule.isWhitelistedAddress(
      parseInt(bountyid),
      whitelisted.address
    );
    console.log(isWhitelisted);
  });
