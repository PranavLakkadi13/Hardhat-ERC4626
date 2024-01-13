const { network, ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  const chainId = network.config.chainId;

  const Vault = await deployments.get("Asset")

  const args = [Vault.address];

  log("Deploying the Token......")
  const VaultContract = await deploy("VaultContract", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  log("Vault Deployed SuccessFully....")
  log("----------------------------------------------------------------")

};

module.exports.tags = ["Vault","all"];