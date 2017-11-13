var SelfDestructContract = artifacts.require("./SelfDestructContract");

module.exports = function(deployer) {
  deployer.deploy(SelfDestructContract);
};
