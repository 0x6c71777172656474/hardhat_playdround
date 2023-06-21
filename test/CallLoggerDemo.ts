import { expect } from "chai";
import { ethers } from "hardhat";
import { CallLoggerDemo } from "../typechain-types";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

describe("CallLoggerDemo contract", async () => {
  let callLoggerDemo: CallLoggerDemo;
  let owner: SignerWithAddress, user: SignerWithAddress;

  beforeEach(async () => {
    [, owner, user] = await ethers.getSigners();
    const Logger = await ethers.getContractFactory("Logger", owner);
    const logger = await Logger.deploy();
    await logger.deployed();

    const CallLoggerDemo = await ethers.getContractFactory(
      "CallLoggerDemo",
      owner
    );
    callLoggerDemo = await CallLoggerDemo.deploy(logger.address);
    await callLoggerDemo.deployed();
  });

  it("Should pay and get payment info", async () => {
    const sum = 100;
    const txData = {
      value: sum,
      to: callLoggerDemo.address,
    };

    const tx = await owner.sendTransaction(txData);
    await tx.wait();

    await expect(tx).changeEtherBalance(callLoggerDemo, sum);
    const amount = await callLoggerDemo.payment(owner.address, 0);
    expect(amount).to.eq(sum);
  });
});
