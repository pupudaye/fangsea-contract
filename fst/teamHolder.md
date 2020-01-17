# 合约介绍

## FSTTokenTeamAgentHolder

    此合约为专门为团队锁仓实现的锁仓合约,阶段解锁比例由发行人设置
    
|     Function                 |               Desc                        |
|:------------------------------------------ |:-------------------|
| addHolderToken(address _adr,uint256 _lockAmount)                         | 添加持有人锁仓额度 |
| subHolderToken(address _adr,uint256 _lockAmount)                       | 减少持有人锁仓额度| 
| releaseMyTokens()                     | 解仓自己的可解额度| 
| releaseTokens(address _adr)                  | 解仓指定人的可解额度| 
| renounceOwnership()    | 释放合约拥有权| 
| transferOwnership(address newOwner)    | 转让合约拥有权|    
| totalLockTokens()    | 获取总锁仓数量|
| totalUNLockTokens()    | 获取总解仓数量|
| hasUnlockNum()    | 从开始锁仓起止时间算可解仓阶段次数|
| hasUnlockAmount()    | 设定解仓次数计算解仓额度|


# ​发行

FSTTokenTeamAgentHolder源代码是TeamHolder.sol文件

## 编译发布FSTTokenTeamAgentHolder源代码是TeamHolder

1. 打开以太坊开发工具http://remix.ethereum.org/#optimize=false&version=soljson-v0.4.25+commit.e67f0147.js
2. 选择编译版本为v0.4.25
3. 将TeamHolder.sol文件内的所有代码复制到工具编辑框内
4. 在Deploy输入框中输入参数：

```
FST 合约地址            锁仓周期  解仓阶段比例
"Fangsea Token address",600,[10,20,30,40]
```



* 测试合约地址-测试FST

|     Contract  |               Address                     |                Desc                     |
|:-----------   |:------------------------------------------|:----------------------------------------|
| FSTToken      | 0xC701BB3C623F6aB8E99b77815fA81b9A8ba862D2 | FST Token 是流通货币 |
| FSTTokenTeamAgentHolder| 0x2C0363eF18E89Af3320e8B3918A2458658D23f82 | 团队持有人锁仓合约   |

* STG合约地址-STG-FST

|     Contract  |               Address                     |                Desc                     |
|:-----------   |:------------------------------------------|:----------------------------------------|
| FSTToken      | 0x4d2a45556aa5951c8dd6885e87ecc74c0462e33b | FST Token 是流通货币 |
| FSTTokenTeamAgentHolder| 0x4c7B1689431b6F0bc313844041dc80570FAA80E9 | 团队持有人锁仓合约   |



