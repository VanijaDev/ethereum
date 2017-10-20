var MultiNumberBettingV1 = artifacts.require("./MultiNumberBettingV1.sol");
var MultiNumberBettingV2 = artifacts.require("./MultiNumberBettingV2.sol");
var MultiNumberBettingV3 = artifacts.require("./MultiNumberBettingV3.sol");

module.exports = function(deployer) {
    deployer.deploy(MultiNumberBettingV1, 1, 2, 3);
    deployer.deploy(MultiNumberBettingV2, 1, 2, 3);
    deployer.deploy(MultiNumberBettingV3, 1, 2, 3);
};