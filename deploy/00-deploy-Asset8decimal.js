const { network, ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  const chainId = network.config.chainId;

  const args = [];

  log("Deploying the Asset8Decimal......")
  const Asset8Decimal = await deploy("Asset8Decimal", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  log("Asset8Decimal Deployed SuccessFully....")
  log("----------------------------------------------------------------")

};

module.exports.tags = ["Asset8Decimal","all"];