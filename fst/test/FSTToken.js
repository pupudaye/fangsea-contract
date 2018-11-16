var FSTToken = artifacts.require("./FSTToken.sol");
var amount = 100000;
contract('FSTToken', function(accounts) {
  it("should init balance value is 0",function () {
      return FSTToken.deployed().then(function (instance) {
          return instance.balanceOf.call(accounts[0]);
      }).then(function(balance) {
          assert.equal(balance.valueOf(), 0, "should init balance value is not 0");
      });
  });
  it("should account[0] is minner",function () {
      return FSTToken.deployed().then(function (instance) {
          return instance.isMinter.call(accounts[0]);
      }).then(function(isMinter) {
          assert.equal(isMinter, true, "should account[0] is not minner");
      });
  });
  it("should cap is "+amount,function () {
      return FSTToken.deployed().then(function (instance) {
          return instance.cap.call();
      }).then(function(hasCap) {
          assert.equal(hasCap, amount, "cap is not equal "+amount);
      });
  });
  it("should mint Token correctly ", function() {
    var fst;
    // Get initial balances of first and second account.
    var account = accounts[0];
    return FSTToken.deployed().then(function(instance) {
      fst = instance;
      return fst.mint(account,amount, {from: account});
    }) .then(function() {
      return fst.balanceOf.call(account);
    }).then(function(balance) {
      assert.equal(balance.toNumber(),amount , "mint token fail");
    });
  });
  it("should transfer Token correctly",function () {
      var fst;
      var transferAmount=1000;
      var sendAccount = accounts[0];
      var receAccount=accounts[1];
      return FSTToken.deployed().then(function (instance) {
          fst = instance;
          return fst.transfer(receAccount,transferAmount,{from:sendAccount});
      }).then(function () {
          return fst.balanceOf.call(receAccount);
      }).then(function (balance) {
          account_one_ending_balance = balance.toNumber();
          assert.equal(balance.toNumber(),transferAmount,"transfer token fail");
      });
  });
});
