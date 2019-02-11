var FSTTokenIssue = artifacts.require("./FSTTokenIssue.sol");
var FSTToken = artifacts.require("./FSTToken.sol");
var FSTTokenHolder = artifacts.require("./FSTTokenHolder.sol");
var decimals=0;
contract('FSTTokenIssue', function(accounts) {
    it("should get decimals correctly ",function () {
        return FSTToken.deployed().then(function (instance) {
            return instance.decimals.call();
        }).then(function(_decimals) {
            decimals=10**_decimals;
        });
    });
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
              var amount=eth/price*decimals;
              assert.equal(lockAmount, amount, "buy Token fail,balance is not "+lockAmount);
            //  assert.equal(web3.fromWei(lockAmount,'ether'), amount, "buy Token fail,balance is not "+lockAmount);
              assert.equal(lockAmount, balance.toNumber(), "buy Token fail,lock and balance is not equal!,"+balance);
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
            return fstIssue.TWhitelist.call(whiteAccounts[0]);
        }).then(function (TWhiteItemValue0) {
            assert.equal(TWhiteItemValue0, TWhiteAccountBonus[0]*decimals, "set Team Holder Token value is not equal,"+TWhiteItemValue0);
           // assert.equal(web3.fromWei(TWhiteItemValue0,'ether'), TWhiteAccountBonus[0], "set Team Holder Token value is not equal,"+TWhiteItemValue0);
            return fstIssue.removeTWhitelist(whiteAccounts[1],{from: owner});
        }).then(function () {
            return fstIssue.TWhitelist.call(whiteAccounts[1]);
        }).then(function (TWhiteItemValue1) {
            assert.equal(TWhiteItemValue1, 0, "remove Team Holder Token  is fail,"+TWhiteItemValue1);
            //assert.equal(web3.fromWei(TWhiteItemValue1,'ether'), 0, "remove Team Holder Token  is fail,"+TWhiteItemValue1);
            return fstIssue.provideTeamHolderToken(whiteAccounts[0],{from: owner});
        }) .then(function () {
            return fSTTokenHolder.holderList.call(whiteAccounts[0]);
        }).then(function (holderSchedule) {
            assert.equal(holderSchedule[1], (TWhiteAccountBonus[0]+1000)*decimals, "provide Team Holder Token value is not equal "+holderSchedule[1]);
           // assert.equal(web3.fromWei(holderSchedule[1],'ether'), TWhiteAccountBonus[0]+1000, "provide Team Holder Token value is not equal "+holderSchedule[1]);
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
