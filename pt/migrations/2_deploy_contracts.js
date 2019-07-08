var GlobalWhitelist = artifacts.require("./GlobalWhitelist.sol");
// var ComplianceService_v1 = artifacts.require("./ComplianceService_v1.sol");
var DefaultService = artifacts.require("./DefaultService.sol");
var ComplianceRegistry = artifacts.require("./ComplianceRegistry.sol");
var PTToken = artifacts.require("./PropertyToken.sol");

module.exports = function(deployer) {
    // deployer.deploy(DefaultService).then(function () {
    //         return deployer.deploy(ComplianceRegistry,DefaultService.address).then(function () {
                return deployer.deploy(PTToken,'TH000002 Token','TH000002',0,1000000000,'0x7df2d8686dc8b104372922416e6eb5554faaa8a7');
    //         });
    // });


};
