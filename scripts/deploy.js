const { ethers } = require("hardhat")

async function main() {

  const AIRDROP = await ethers.getContractFactory("MyPGUpgradeable");
  const aIRDROP = await AIRDROP.deploy();

  await aIRDROP.deployed();

  console.log("AIRDROP Address: ", aIRDROP.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
