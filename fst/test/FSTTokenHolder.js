// var FSTTokenHolder = artifacts.require("./FSTTokenHolder.sol");
// var FSTToken = artifacts.require("./FSTToken.sol");
// // var FSTTokenIssue = artifacts.require("./FSTTokenIssue.sol");
// contract('FSTTokenHolder', function(accounts) {
//     var fSTTokenHolder;
//     var owner=accounts[0];
//     var fstToken;
//     var whiteAccounts=[accounts[1],accounts[2]];
//     /**
//      * todo FSTTokenHolder set agent and  Holder
//      */
//     it("should set agent and  Holder is correctly",function () {
//         var holderAmount=10000;
//         var agentAccount=owner;
//         return FSTToken.deployed().then(function (instance) {
//             fstToken=instance;
//             return fstToken.mint(FSTTokenHolder.address,holderAmount,{from:owner});
//         }).then(function () {
//             return FSTTokenHolder.deployed().then(function (instance) {
//                 fSTTokenHolder=instance;
//                 return instance.setAgent(agentAccount,{from:owner});
//             }).then(function () {
//                 return fSTTokenHolder.setHolder(whiteAccounts[0],holderAmount,{from:agentAccount});
//             }).then(function () {
//                 return fSTTokenHolder.holderList.call(whiteAccounts[0],{from:owner});
//             }).then(function (holderSchedule) {
//                 assert.equal(holderSchedule[1], holderAmount, "set agent and  Holder is fail,setRes="+holderSchedule[1]);
//             });
//         });
//     })
//
//     /**
//      * todo FSTTokenHolder releaseMyTokens
//      */
//     // it("should releaseMyTokens is correctly",function () {
//     //     return FSTTokenHolder.deployed().then(function (instance) {
//     //         fSTTokenHolder=instance;
//     //         return fSTTokenHolder.releaseMyTokens({from:owner});
//     //     })
//     // });
//     /**
//      * todo FSTTokenHolder releaseTokens
//      */
//     // setTimeout(function(){
//     // it("should releaseTokens is correctly",function () {
//     //         return FSTTokenHolder.deployed().then(function (instance) {
//     //             fSTTokenHolder=instance;
//     //             return fSTTokenHolder.releaseTokens(whiteAccounts[0],{from:owner});
//     //         }).then(function () {
//     //             return fstToken.balanceOf.call(whiteAccounts[0]);
//     //         }).then(function (balance) {
//     //             assert.equal(balance, 1, "release Token value is "+balance);
//     //         });
//     // });
//     // }, 75);
//     /**
//      * todo destory contract,transfer eth
//      */
//     it("should destory run is correctly",function () {
//         // var ethBalance=web3.eth.getBalance(owner);
//         FSTTokenHolder.deployed().then(function (instance) {
//             return instance.destory(accounts[9],{from: owner});
//         }).then(function () {
//             // assert.equal(100,1,"ethBalance="+ethBalance);
//         });
//     });
// });
