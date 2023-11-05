const { network, ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  const chainId = network.config.chainId;

  const args = [];

  log("Deploying the Token......")
  const Asset = await deploy("Asset", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  log("Token Deployed SuccessFully....")
  log("----------------------------------------------------------------")

};

module.exports.tags = ["Asset","all"];