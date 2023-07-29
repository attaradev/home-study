import { ethers } from "hardhat";

async function deployBankContract() {
  const bank = await ethers.deployContract("Bank");
  await bank.waitForDeployment();
  console.log(`Bank deployed to ${bank.target}`);
}

async function deployBallotContract() {
  const proposalNames = ["Proposal 1", "Proposal 2", "Proposal 3"];
  const ballot = await ethers.deployContract("Ballot", [proposalNames]);
  await ballot.waitForDeployment();
  console.log(`Ballot deployed to ${ballot.target}`);
}

async function deployLockContract() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const unlockTime = currentTimestampInSeconds + 60;

  const lockedAmount = ethers.parseEther("0.001");

  const lock = await ethers.deployContract("Lock", [unlockTime], {
    value: lockedAmount,
  });

  await lock.waitForDeployment();

  console.log(
    `Lock with ${ethers.formatEther(
      lockedAmount
    )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.target}`
  );
}

async function main() {
  await deployBankContract();
  await deployBallotContract();
  await deployLockContract();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
