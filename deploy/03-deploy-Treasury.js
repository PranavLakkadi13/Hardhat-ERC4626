const { network, ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  const chainId = network.config.chainId;

  const args = [];

  log("Deploying the Treasury......")
  const Treasury = await deploy("Treasury", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  log("Treasury Deployed SuccessFully....")
  log("----------------------------------------------------------------")

};

module.exports.tags = ["Treasury","all"];