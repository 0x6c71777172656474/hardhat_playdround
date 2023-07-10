import { expect } from "chai";
import { ethers } from "hardhat";
import { Shop } from "../typechain-types";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { toMixedChecksumAddress } from "../scripts/common";

describe("Shop actions", async () => {
  let owner: SignerWithAddress, buyer: SignerWithAddress;
  let contractAddress: string = "0x495f947276749Ce646f68AC8c248420045cb7b5e"
  let shop: Shop;

  beforeEach(async () => {
    [, owner, buyer] = await ethers.getSigners();
    const Shop = await ethers.getContractFactory("Shop", owner);
    shop = await Shop.deploy();
    await shop.deployed();
  });

  it("Should buy some tokens", async () => {
    console.log(toMixedChecksumAddress("0x2ca8e0c643bde4c2e08ab1fa0da3401adad7734d"));

    // const sum = 0;
    // const txData = {
    //   value: sum,
    //   to: shop.address,
    // };

    // const tx = await owner.sendTransaction(txData);
    // const a = await tx.wait();
    // console.log(a);
    // await expect(tx).changeEtherBalance(shop, sum);
    // const amount = await callLoggerDemo.payment(owner.address, 0);
    // expect(amount).to.eq(sum);
  })
});
