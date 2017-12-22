var Migrations = artifacts.require("./Migrations.sol");
var SimpleWallet = artifacts.require("./SimpleWallet.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(SimpleWallet);
};
