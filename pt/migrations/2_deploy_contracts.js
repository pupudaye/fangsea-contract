var GlobalWhitelist = artifacts.require("./GlobalWhitelist.sol");
var ComplianceService_v1 = artifacts.require("./ComplianceService_v1.sol");
var ComplianceRegistry = artifacts.require("./ComplianceRegistry.sol");
var PTToken = artifacts.require("./PropertyToken.sol");

module.exports = function(deployer) {
    deployer.deploy(GlobalWhitelist).then(function () {
        return deployer.deploy(ComplianceService_v1,GlobalWhitelist.address).then(function () {
            return deployer.deploy(ComplianceRegistry,ComplianceService_v1.address).then(function () {
                return deployer.deploy(PTToken,ComplianceRegistry.address,'PT Token','PT',18,100000);
            });
        });
    });



};
