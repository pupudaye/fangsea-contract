var PTToken = artifacts.require("./PropertyToken.sol");
var GlobalWhitelist = artifacts.require("./GlobalWhitelist.sol");
var ComplianceService = artifacts.require("./ComplianceService_v1.sol");

contract('PTToken', function(accounts) {

    var pt;
    var amount =web3.toWei(100000,'ether');
    var sendAccount = accounts[0];
    var receAccount1=accounts[1];
    var spenderAccount=accounts[2];
    var receAccount2=accounts[3];

  it("should init totalSupply correctly ",function () {
      return PTToken.deployed().then(function (instance) {
          pt = instance;
          return pt.balanceOf.call(accounts[0]);
      }).then(function(balance) {
          assert.equal(balance.toNumber(), amount, "should init balance value is not "+balance.toNumber());
      });
  });
  it("should set Whitelist correctly",function () {
        var gw;
        return GlobalWhitelist.deployed().then(function (instance) {
            gw=instance;
            return gw.setWhitelist(sendAccount,'THA',true,true,true,{from:sendAccount});
        }).then(function () {
            return gw.setWhitelist(receAccount1,'THA',true,true,true,{from:sendAccount});
        }).then(function () {
            return gw.setWhitelist(spenderAccount,'THA',true,true,true,{from:sendAccount});
        }).then(function () {
            return gw.setWhitelist(receAccount2,'THA',true,true,true,{from:sendAccount});
        }).then(function () {
            return gw.setWhitelist(accounts[4],'THA',true,true,true,{from:sendAccount});
        });
  });
    it("should change Whitelist correctly", function () {
        var gw;
        return GlobalWhitelist.deployed().then(function (instance) {
            gw=instance;
            return gw.changeTrust(accounts[4],false,{from:sendAccount});
        }).then(function () {
            return gw.changeCanSend(accounts[4],false,{from:sendAccount});
        }).then(function () {
            return gw.changeCanReceive(accounts[4],false,{from:sendAccount});
        });
    });
    it('should change ComplianceService correctly', function () {
        var cs;
        return ComplianceService.deployed().then(function (instance) {
            cs=instance;
            return cs.setCanTransferDecimal(true,{from:sendAccount});
        }).then(function () {
            return cs.canTransferDecimal.call({from:sendAccount});
        }).then(function (res) {
            assert.equal(res,true,"ComplianceService of setCanTransferDecimal fail res="+res);
            return cs.setLock(true,7200,{from:sendAccount});
        }).then(function () {
            return cs.lockSchedule.call({from:sendAccount});
        }).then(function (lockSchedule) {
            assert.equal(lockSchedule[0],true,"ComplianceService of setLock fail lockSchedule[0]="+lockSchedule[0]);
            // assert.equal(lockSchedule[1],true,"ComplianceService of setLock fail lockSchedule[0]="+lockSchedule[1]);
            assert.equal(lockSchedule[2],7200,"ComplianceService of setLock fail lockSchedule[0]="+lockSchedule[2]);
            return cs.setCanTransferDecimal(false,{from:sendAccount});
        }).then(function () {
            return cs.setLock(false,0,{from:sendAccount});
        });
    });
    it("should transfer Token correctly",function () {
      var transferAmount=web3.toWei(1000,'ether');
      return PTToken.deployed().then(function (instance) {
          pt = instance;
          return pt.transfer(receAccount1,transferAmount,{from:sendAccount});
      }).then(function () {
          return pt.balanceOf.call(receAccount1);
      }).then(function (balance) {
          assert.equal(balance.toNumber(),transferAmount,"transfer token fail");
      });
  });

  it("should allowance correctly",function () {
        var spenderAmount=web3.toWei(100,'ether');
        return PTToken.deployed().then(function (instance) {
            pt = instance;
            return pt.approve(spenderAccount,spenderAmount,{from:receAccount1});
        }).then(function () {
            return pt.allowance.call(receAccount1,spenderAccount);
        }).then(function (allowanceAmount) {
            assert.equal(allowanceAmount.toNumber(),spenderAmount,"call approve fail,allowance Amount="+allowanceAmount);
            return pt.increaseAllowance(spenderAccount,spenderAmount,{from:receAccount1});
        }).then(function () {
            return pt.allowance.call(receAccount1,spenderAccount);
        }).then(function (allowanceAmount) {
            assert.equal(allowanceAmount.toNumber(),spenderAmount*2,"call increaseAllowance fail,allowance Amount="+allowanceAmount);
            return pt.decreaseAllowance(spenderAccount,spenderAmount,{from:receAccount1});
        }).then(function () {
            return pt.allowance.call(receAccount1,spenderAccount);
        }).then(function (allowanceAmount) {
            assert.equal(allowanceAmount.toNumber(),spenderAmount,"call decreaseAllowance fail,allowanceAmount="+allowanceAmount);
        });
  });

  it("should transferFrom Token correctly",function () {
      var transferFromAmount=web3.toWei(10,'ether');
      var receAccount1Balance=0;
      var receAccount2Balance=0;

      return PTToken.deployed().then(function (instance) {
          pt = instance;
          return pt.balanceOf.call(receAccount1);
      }).then(function (balance) {
          receAccount1Balance=balance.toNumber();
          return pt.transferFrom(receAccount1,receAccount2,transferFromAmount,{from:spenderAccount});
      }).then(function () {
          return pt.balanceOf.call(receAccount2);
      }).then(function (balance) {
          receAccount2Balance=balance.toNumber();
          assert.equal(receAccount2Balance,transferFromAmount,"call transferFrom fail,balance="+receAccount2Balance);
          return pt.balanceOf.call(receAccount1);
      }).then(function (balance) {
          assert.equal(balance,receAccount1Balance-receAccount2Balance,"call transferFrom fail,balance="+balance);
      });
  });

  it('it should setBuyBack correctly',function () {
      return PTToken.deployed().then(function (instance) {
          pt = instance;
          return pt.setBuyBack('0x61f657ad83844f6439d41edb55aa01533a4e366a',web3.toWei(0.001,'ether'),{from:sendAccount});
      })
  });
    // it('should setHolderList correctly', function () {
    //     return PTToken.deployed().then(function (instance) {
    //         pt = instance;
    //         return pt.setHolderList(receAccount1,{from:sendAccount});
    //     }).then(function (res) {
    //         assert.equal(1,2,"call setHolderList fail,res="+res);
    //     })
    // });
    // it('should buyBack Token correctly', function () {
    //     var buyBackAccount=accounts[4];
    //     return PTToken.deployed().then(function (instance) {
    //         pt = instance;
    //         return pt.buyBack(buyBackAccount,{from:sendAccount});
    //     }).then(function () {
    //         return pt.balanceOf.call(receAccount1);
    //     }).then(function (balance) {
    //         assert.equal(balance,0,"call buyBack fail,balance="+balance);
    //         return pt.balanceOf.call(spenderAccount);
    //     }).then(function (balance) {
    //         assert.equal(balance,0,"call buyBack fail,balance="+balance);
    //         return pt.balanceOf.call(receAccount2);
    //     }).then(function (balance) {
    //         assert.equal(balance,0,"call buyBack fail,balance="+balance);
    //         return pt.balanceOf.call(buyBackAccount);
    //     }).then(function (balance) {
    //         assert.equal(balance.toNumber(),amount,"call buyBack fail,balance="+balance.toNumber());
    //     });
    // });
    it("should destory Contract correctly",function () {
        return PTToken.deployed().then(function (instance) {
            pt = instance;
            return pt.destory(accounts[9],{from: sendAccount});
        }).then(function () {
        });
    });
});
