//var ConvertLib = artifacts.require("./ConvertLib.sol");
//var MetaCoin = artifacts.require("./MetaCoin.sol");
var FSTToken = artifacts.require("./FSTToken.sol");
var FSTTokenHolder = artifacts.require("./FSTTokenHolder.sol");
var FSTTokenIssue = artifacts.require("./FSTTokenIssue.sol");

module.exports = function(deployer,network,accounts) {
  //deployer.deploy(ConvertLib);
 // deployer.link(ConvertLib, MetaCoin);
  //deployer.deploy(MetaCoin);
   //if (network == "development") {
        // Do something specific to the network named "development".
        deployer.deploy(FSTToken,'Fangsea Token','FST',18,100000).then(function () {
            return deployer.deploy(FSTTokenHolder,FSTToken.address,600).then(function () {
                return deployer.deploy(FSTTokenIssue,FSTToken.address,1000000000000000,70000,FSTTokenHolder.address);
            });
        });
   // } else {
        // Perform a different step otherwise.
  //  }


};
