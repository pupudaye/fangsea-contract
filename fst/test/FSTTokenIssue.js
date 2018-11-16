var FSTTokenIssue = artifacts.require("./FSTTokenIssue.sol");
var FSTToken = artifacts.require("./FSTToken.sol");
var FSTTokenHolder = artifacts.require("./FSTTokenHolder.sol");

contract('FSTTokenIssue', function(accounts) {

    /**
     * todo FSTTokenIssue set Owhitelist
     */
    var whiteAccounts=[accounts[1],accounts[2]];
    var owner=accounts[0];
    var fstIssue;
  it("should set OWhitelist is correctly",function () {
      return FSTTokenIssue.deployed().then(function (instance) {
          fstIssue=instance;
          return fstIssue.setOWhitelist(whiteAccounts,{from: owner});
      }).then(function() {
          return fstIssue.OWhitelist.call(whiteAccounts[0]);
      }).then(function (hasWhite) {
          assert.equal(hasWhite, true, "set OWhitelist fail");
      }).then(function () {
          return fstIssue.removeOWhitelist(whiteAccounts[1],{from: owner});
      }).then(function () {
          return fstIssue.OWhitelist.call(whiteAccounts[1]);
      }).then(function (hasWhite) {
          assert.equal(hasWhite, false, "remove OWhitelist fail");
      });
  });
    /**
     * todo FSTTokenIssue  buy token
     */
    var fstToken;
    var fSTTokenHolder;
  it("should buy token is correctly",function () {
      var eth=1;
      var price=0.001;
      var lockAmount;
      return FSTToken.deployed().then(function (instance) {
          fstToken=instance;
          return fstToken.addMinter(FSTTokenIssue.address,{from:accounts[0]});
      }).then(function () {
          return FSTTokenHolder.deployed().then(function (instance) {
              fSTTokenHolder=instance;
              return fSTTokenHolder.setAgent(FSTTokenIssue.address,{from:owner});
          }).then(function () {
              return fstIssue.buy({from: whiteAccounts[0],value:web3.toWei(eth,'ether')});
          }) .then(function () {
              return fSTTokenHolder.holderList.call(whiteAccounts[0],{from:owner});
          }).then(function (holderSchedule) {
              lockAmount=holderSchedule[1];
              return fstToken.balanceOf.call(FSTTokenHolder.address);
          }).then(function (balance) {
              var amount=eth/price;
              assert.equal(lockAmount, amount, "buy Token fail,balance is not "+amount);
              assert.equal(lockAmount, balance.toNumber(), "buy Token fail,lock and balance is not equal!");
          });
      });

  });
    /**
     *  todo FSTTokenIssue set TWhitelist and provide Team Holder Token
     */
    var TWhiteAccountBonus=[3000,2000];
    it("should set TWhitelist and provide Team Holder Token is correctly",function () {
        return FSTTokenIssue.deployed().then(function (instance) {
            fstIssue=instance;
            return fstIssue.setTWhitelist(whiteAccounts,TWhiteAccountBonus,{from: owner});
        }).then(function () {
            return fstIssue.TWhitelist.call(0);
        }).then(function (TWhiteItem) {
            assert.equal(TWhiteItem[1], TWhiteAccountBonus[0], "set Team Holder Token value is not equal");
            return fstIssue.removeTWhitelist(whiteAccounts[1],{from: owner});
        }).then(function () {
            return fstIssue.TWhitelist.call(1);
        }).then(function (TWhiteItem) {
            assert.equal(TWhiteItem[1], 0, "remove Team Holder Token  is fail");
            return fstIssue.provideTeamHolderToken({from: owner});
        }).then(function () {
            return fSTTokenHolder.holderList.call(whiteAccounts[0]);
        }).then(function (holderSchedule) {
            assert.equal(holderSchedule[1], TWhiteAccountBonus[0], "provide Team Holder Token value is not equal "+holderSchedule[1]);
        });
    });
    /**
     * todo destory contract,transfer eth
     */
    it("should destory run is correctly",function () {
        // var ethBalance=web3.eth.getBalance(owner);
        FSTTokenIssue.deployed().then(function (instance) {
           fstIssue=instance;
           return fstIssue.destory(accounts[9],{from: owner});
        }).then(function () {
            // assert.equal(100,1,"ethBalance="+ethBalance);
        });
    });
});
