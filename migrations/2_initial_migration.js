var MyContract = artifacts.require("Land");

module.exports = function(deployer) {
  deployer.deploy(MyContract);
};
