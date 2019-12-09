var FSTTokenTeamAgentHolder = artifacts.require("./FSTTokenTeamAgentHolder.sol");
var FSTToken = artifacts.require("./FSTToken.sol");
contract('FSTTokenTeamAgentHolder', function(accounts) {
    var FSTTokenTeamAgentHolderInstance;
    var owner=accounts[0];
    var whiteAccounts=[accounts[1],accounts[2]];
    var decimals=10**18;
    /**
     * todo FSTTokenAgentHolder set agent and  Holder
     */
    it("should set agent and  Holder is correctly",function () {
        var holderAmount=10000*decimals;
        return FSTTokenTeamAgentHolder.deployed().then(function (instance) {
            FSTTokenTeamAgentHolderInstance=instance;
            return FSTTokenTeamAgentHolderInstance.addHolderToken(whiteAccounts[0],10000,{from:owner});
        }).then(function () {
            return FSTTokenTeamAgentHolderInstance.subHolderToken(whiteAccounts[0],5000,{from:owner});
        }).then(function () {
            return FSTTokenTeamAgentHolderInstance.addHolderToken(whiteAccounts[0],5000,{from:owner});
        }).then(function () {
            return FSTTokenTeamAgentHolderInstance.addHolderToken(whiteAccounts[1],5000,{from:owner});
        }).then(function () {
            return FSTTokenTeamAgentHolderInstance.holderList.call(whiteAccounts[0],{from:owner});
        }).then(function (holderSchedule) {
            assert.equal(holderSchedule[1], holderAmount, "set agent and  Holder is fail,setRes="+holderSchedule[1]);
            assert.equal(holderSchedule[2], 0, "set agent and  Holder is fail,setRes="+holderSchedule[2]);
            assert.equal(holderSchedule[5], false, "set agent and  Holder is fail,setRes="+holderSchedule[5]);
           return FSTTokenTeamAgentHolderInstance.holderAccountList.call(0,{from:owner});
         }).then(function (address) {
            assert.equal(whiteAccounts[0], address, "set holderAccountList 0 is "+address);
            return FSTTokenTeamAgentHolderInstance.holderAccountList.call(1,{from:owner});
        }).then(function (address) {
            assert.equal(whiteAccounts[1], address, "set holderAccountList 1 is "+address);
        });
    })


    it("should get totalLockTokens is correctly",function () {
        return FSTTokenTeamAgentHolder.deployed().then(function (instance) {
            FSTTokenTeamAgentHolderInstance=instance;
            return FSTTokenTeamAgentHolderInstance.totalLockTokens.call({from:owner});
        }).then(function (totalLockTokens) {
            assert.equal(totalLockTokens,15000*decimals, "release Token value is "+totalLockTokens);
        });
    });

    it("should get totalUNLockTokens is correctly",function () {
        return FSTTokenTeamAgentHolder.deployed().then(function (instance) {
            FSTTokenTeamAgentHolderInstance=instance;
            return FSTTokenTeamAgentHolderInstance.totalUNLockTokens.call({from:owner});
        }).then(function (totalUNLockTokens) {
            assert.equal(totalUNLockTokens,0, "release Token value is "+totalUNLockTokens);
        });
    });
    it("should hasUnlockNum read is correctly",function () {
        return FSTTokenTeamAgentHolder.deployed().then(function (instance) {
            FSTTokenTeamAgentHolderInstance=instance;
            return FSTTokenTeamAgentHolderInstance.hasUnlockNum.call(whiteAccounts[0],1595871195,{from:owner});
        }).then(function (unlockNum) {
            assert.equal(unlockNum,4, "unlockNum value is "+unlockNum);
        });
    });
    it("should hasUnlockAmount read is correctly",function () {
        return FSTTokenTeamAgentHolder.deployed().then(function (instance) {
            FSTTokenTeamAgentHolderInstance = instance;
            return FSTTokenTeamAgentHolderInstance.hasUnlockAmount.call(whiteAccounts[0], 0, {from: owner});
        }).then(function (unlockAmount) {
            assert.equal(unlockAmount,0, "unlockAmount value is "+unlockAmount);
            return FSTTokenTeamAgentHolderInstance.hasUnlockAmount.call(whiteAccounts[0],1,{from:owner});
        }).then(function (unlockAmount) {
            var holderAmount=1000*decimals;
            assert.equal(unlockAmount,holderAmount, "unlockAmount value is "+unlockAmount);
            return FSTTokenTeamAgentHolderInstance.hasUnlockAmount.call(whiteAccounts[0],2,{from:owner});
        }).then(function (unlockAmount) {
            var holderAmount=3000*decimals;
            assert.equal(unlockAmount,holderAmount, "unlockAmount value is "+unlockAmount);
            return FSTTokenTeamAgentHolderInstance.hasUnlockAmount.call(whiteAccounts[0],3,{from:owner});
        }).then(function (unlockAmount) {
            var holderAmount=6000*decimals;
            assert.equal(unlockAmount,holderAmount, "unlockAmount value is "+unlockAmount);
            return FSTTokenTeamAgentHolderInstance.hasUnlockAmount.call(whiteAccounts[0],4,{from:owner});
        }).then(function (unlockAmount) {
            var holderAmount=10000*decimals;
            assert.equal(unlockAmount,holderAmount, "unlockAmount value is "+unlockAmount);
            return FSTTokenTeamAgentHolderInstance.hasUnlockAmount.call(whiteAccounts[0],5,{from:owner});
        }).then(function (unlockAmount) {
            assert.equal(unlockAmount,0, "unlockAmount value is "+unlockAmount);
        });
    });
    // var fstToken;
    // /**
    //  * todo FSTTokenHolder releaseTokens
    //  */
    // it("should releaseTokens is correctly",function () {
    //     return FSTToken.deployed().then(function (instance) {
    //         fstToken=instance;
    //         return fstToken.addMinter(FSTTokenAgentHolder.address,{from:owner});
    //     }).then(function() {
    //         return FSTTokenAgentHolder.deployed().then(function (instance) {
    //             fSTTokenAgentHolder=instance;
    //             return fSTTokenAgentHolder.releaseTokens(whiteAccounts[0],{from:owner});
    //         }).then(function () {
    //             return fstToken.balanceOf.call(whiteAccounts[0]);
    //         }).then(function (balance) {
    //             assert.equal(balance,0, "release Token value is "+balance);
    //         });
    //     });
    //
    // });
    /**
     * todo FSTTokenHolder releaseMyTokens
     */
    // it("should releaseMyTokens is correctly",function () {
    //     return FSTTokenAgentHolder.deployed().then(function (instance) {
    //         fSTTokenAgentHolder=instance;
    //         return fSTTokenAgentHolder.releaseMyTokens({from:whiteAccounts[0]});
    //     }).then(function () {
    //         return fstToken.balanceOf.call(whiteAccounts[0]);
    //     }).then(function (balance) {
    //         assert.equal(balance,0, "release Token value is "+balance);
    //     });
    // });
});
