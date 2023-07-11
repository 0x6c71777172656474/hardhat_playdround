import { expect } from "chai";
import { ethers } from "hardhat";
import { Bush, Bush__factory } from "../typechain-types";

describe("Merkle Tree test via Bush contract", async () => {
  let bush: Bush;
  beforeEach(async () => {
    let Bush: Bush__factory = await ethers.getContractFactory("Bush");
    bush = await Bush.deploy();
    await bush.deployed();
  });

  it("Verification should be passed", async () => {
    expect(await bush.verify("1tx Jimm to Sara", 1, await bush.hashes(6), [
        await bush.hashes(0),
        await bush.hashes(5),
      ])).to.equal(true);
  });

  it("Verification should be failed", async () => {
    expect(await bush.verify("1tx Jimm to Sara", 1, await bush.hashes(6), [
        await bush.hashes(0),
        await bush.hashes(4),
      ])).to.equal(false);
  });
});
