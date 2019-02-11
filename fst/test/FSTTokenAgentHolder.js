var FSTTokenAgentHolder = artifacts.require("./FSTTokenAgentHolder.sol");
var FSTToken = artifacts.require("./FSTToken.sol");
contract('FSTTokenAgentHolder', function(accounts) {
    var fSTTokenAgentHolder;
    var owner=accounts[0];
    var whiteAccounts=[accounts[1],accounts[2]];
    /**
     * todo FSTTokenAgentHolder set agent and  Holder
     */
    it("should set agent and  Holder is correctly",function () {
        var holderAmount=10000;
        return FSTTokenAgentHolder.deployed().then(function (instance) {
            fSTTokenAgentHolder=instance;
            return fSTTokenAgentHolder.addHolderToken(whiteAccounts[0],10000,{from:owner});
        }).then(function () {
            return fSTTokenAgentHolder.subHolderToken(whiteAccounts[0],5000,{from:owner});
        }).then(function () {
            return fSTTokenAgentHolder.addHolderToken(whiteAccounts[0],5000,{from:owner});
        }).then(function () {
            return fSTTokenAgentHolder.holderList.call(whiteAccounts[0],{from:owner});
        }).then(function (holderSchedule) {
            assert.equal(holderSchedule[1], holderAmount, "set agent and  Holder is fail,setRes="+holderSchedule[1]);
            assert.equal(holderSchedule[2], 0, "set agent and  Holder is fail,setRes="+holderSchedule[2]);
            assert.equal(holderSchedule[4], false, "set agent and  Holder is fail,setRes="+holderSchedule[4]);
        });
    })

    var fstToken;
    /**
     * todo FSTTokenHolder releaseTokens
     */
    it("should releaseTokens is correctly",function () {
        return FSTToken.deployed().then(function (instance) {
            fstToken=instance;
            return fstToken.addMinter(FSTTokenAgentHolder.address,{from:owner});
        }).then(function() {
            return FSTTokenAgentHolder.deployed().then(function (instance) {
                fSTTokenAgentHolder=instance;
                return fSTTokenAgentHolder.releaseTokens(whiteAccounts[0],{from:owner});
            }).then(function () {
                return fstToken.balanceOf.call(whiteAccounts[0]);
            }).then(function (balance) {
                assert.equal(balance,0, "release Token value is "+balance);
            });
        });

    });
    /**
     * todo FSTTokenHolder releaseMyTokens
     */
    it("should releaseMyTokens is correctly",function () {
        return FSTTokenAgentHolder.deployed().then(function (instance) {
            fSTTokenAgentHolder=instance;
            return fSTTokenAgentHolder.releaseMyTokens({from:whiteAccounts[0]});
        }).then(function () {
            return fstToken.balanceOf.call(whiteAccounts[0]);
        }).then(function (balance) {
            assert.equal(balance,0, "release Token value is "+balance);
        });
    });
    /**
     * todo destory contract,transfer eth
     */
    it("should destory run is correctly",function () {
        // var ethBalance=web3.eth.getBalance(owner);
        FSTTokenAgentHolder.deployed().then(function (instance) {
            return instance.destory(accounts[9],{from: owner});
        }).then(function () {
            // assert.equal(100,1,"ethBalance="+ethBalance);
        });
    });
});
