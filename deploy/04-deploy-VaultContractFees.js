const { network, ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deployer } = await getNamedAccounts();
  const { deploy, log } = deployments;
  const chainId = network.config.chainId;

  const Vault = await deployments.get("Asset")
  const Treasury = await deployments.get("Treasury");

  const args = [Vault.address,100,Treasury.address];

  log("Deploying the Vault With Fees......")
  const VaultWithFee = await deploy("VaultWithFee", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  log("Vault With Fees contract Deployed SuccessFully....")
  log("----------------------------------------------------------------")

};

module.exports.tags = ["VaultWithFee","all"];