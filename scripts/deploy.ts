import hre, { ethers } from "hardhat";
import { Randomizer, Randomizer__factory } from "../typechain-types";
import "dotenv/config";
import { PromiseOrValue } from "../typechain-types/common";

async function main() {
  const randomizerFactory: Randomizer__factory =
    await ethers.getContractFactory("Randomizer");

  const randomizer: Randomizer = await randomizerFactory.deploy(
    process.env.CHAINLINK_SUBSCRIBER_ID || 0,
    "0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D"
  );

  await randomizer.deployed();

  console.log(randomizer.address);

  await hre.run("verify:verify", {
    address: randomizer.address,
    constructorArguments: [
      process.env.CHAINLINK_SUBSCRIBER_ID || 0,
      "0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D",
    ],
  });
}

async function processString(value: PromiseOrValue<string>): Promise<string> {
  const resolvedValue: string = await Promise.resolve(value);
  return resolvedValue;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
