# 合约介绍

##  FSTToken
 
    FST是符合ERC20标准的加密货币,有最大限额并且不可增发;提供Token的基础交易功能;其中包括以下可用函数：
    
|     Function                 |               Desc                        |
|:------------------------------------------ |:-------------------|
| name()                         | 获取Token名称 |
| symbol()                       | 获取Token符号| 
| decimals()                     | 获取Token精度| 
| totalSupply()                  | 获取Token已发行总量| 
| cap()                          | 获取最大发行总量| 
| balanceOf(address owner)       | 获取用户余额| 
| allowance(address owner,address spender)    | 是否允许代理转账| 
| transfer(address to, uint256 value)    | 向指定人转账| 
| approve(address spender, uint256 value)    | 授权代理人和代理金额| 
| transferFrom(address from,address to,uint256 value)    | 代理人转账| 
| increaseAllowance(address spender, uint256 addedValue)    | 增加代理人代理金额| 
| decreaseAllowance(address spender,uint256 subtractedValue)    | 减少代理人代理金额| 
| addMinter(address account)    | 设置铸造货币的权限账号| 
| renounceMinter()    | 删除自己的铸造货币的权限| 
| mint(address to, uint256 value)    | 具备铸造权限的人可以铸造Token货币| 
| renounceOwnership()    | 释放合约拥有权| 
| transferOwnership(address newOwner)    | 转让合约拥有权| 

## FSTTokenAgentHolder

    此合约为投资人和团队分配的锁仓合约,因采用现金收款方式进行融资,所以锁仓名单由管理员来增加和减少;
    到期主动发起或系统自动解锁(需求应用系统配合)到持有人钱包账号
    
|     Function                 |               Desc                        |
|:------------------------------------------ |:-------------------|
| addHolderToken(address _adr,uint256 _lockAmount)                         | 添加持有人锁仓额度 |
| subHolderToken(address _adr,uint256 _lockAmount)                       | 减少持有人锁仓额度| 
| releaseMyTokens()                     | 解仓自己的可解额度| 
| releaseTokens(address _adr)                  | 解仓指定人的可解额度| 
| releaseEachTokens()                          | 解仓所有人的可解额度| 
| renounceOwnership()    | 释放合约拥有权| 
| transferOwnership(address newOwner)    | 转让合约拥有权|    
| totalLockTokens()    | 获取总锁仓数量|
| totalUNLockTokens()    | 获取总解仓数量|

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
## 准备钱包

1. 创建测试钱包和主链钱包
2. 分别为不同钱包获取1-2个ETH

## 获取合约代码

1. FSTToken源代码是 FST-Reslease.sol文件
2. FSTTokenAgentHolder源代码是FSTHolder-Reslease.sol文件
3. FSTTokenTeamAgentHolder源代码是TeamHolder.sol文件

## 编译发布FSTToken

1. 打开以太坊开发工具http://remix.ethereum.org/#optimize=false&version=soljson-v0.4.25+commit.e67f0147.js
2. 选择编译版本为v0.4.25
3. 将FST-Reslease.sol文件内的所有代码复制到工具编辑框内
4. 检查编译结果是否正确(如图)
![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/1.png)
5. 登录Chroom浏览Metamask钱包,如果使用的其他钱包创建的可以采用助记词导入
6. 切换到RUN选项卡
![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/2.png)
7. 在Deploy输入框中输入：

|     名称  |     符号  |     精度  |     数量  |
|:-----------   |:-----------|:------------|:------------|
| "Fangsea Token"      | "FST" | 18 | 1000000000|

参数：
```
"Fangsea Token","FST",18,1000000000
```



8. 点击发行工具里面的Deploy按钮 这个时候将会触发Metamask钱包,完成交易即可
![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/3.png)
9. 回到发行工具里面获取合约地址,将合约地址保存(切记)
![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/4.png)
10. 打开区块链浏览器,搜索合约地址
    测试链：https://ropsten.etherscan.io
    主链：https://etherscan.io
    ![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/5.png)
11. 发布合约代码

第一步：
![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/6.png)

第二步：

![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/7.png)

第三步：

![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/8.png)

第四步：

![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/9.png)

## 编译发布FSTTokenAgentHolder
1. 打开以太坊开发工具http://remix.ethereum.org/#optimize=false&version=soljson-v0.4.25+commit.e67f0147.js
2. 选择编译版本为v0.4.25
3. 将FSTHolder-Reslease.sol文件内的所有代码复制到工具编辑框内
4. 检查编译结果是否正确(如图)

![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/10.png)

5. 登录Chroom浏览Metamask钱包,如果使用的其他钱包创建的可以采用助记词导入
6. 切换到RUN选项卡

![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/2.png)

7. 在Deploy输入框中输入：

|     FST合约地址  |     锁仓总时长(秒)  |     分几次解仓  |
|:-----------   |:-----------|:------------|
| 0x38998915970022d40887a82e5abd65e7d9b48ea4      | 31536000 | 4 |

参数：
```
0x38998915970022d40887a82e5abd65e7d9b48ea4,31536000,4
```


<label style="color:red">备注：此处的合约地址为发布的FSTToken合约地址</lable>

8. 以下步骤同发布FSTToken合约的8-11步骤

## 授权铸币角色
1. 使用FSTToken合约地址进入区块链浏览器
2. 切换至writeContract选项卡

![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/11.png)

3. 授权锁仓合约地址为FSTToken可铸币角色

![image](https://raw.githubusercontent.com/pupudaye/fangsea-contract/master/fst/images/12.png)

# 合约地址
* 测试合约地址-测试FST

|     Contract  |               Address                     |                Desc                     |
|:-----------   |:------------------------------------------|:----------------------------------------|
| FSTToken      | 0x61f657ad83844f6439d41edb55aa01533a4e366a | FST Token 是流通货币 |
| FSTTokenAgentHolder| 0x7b2d9d2e722bc72a4bd261a9e8b6d4925bfd1a91 | 持有人锁仓合约   |


* 测试合约地址-STG FST

|     Contract  |               Address                     |                Desc                     |
|:-----------   |:------------------------------------------|:----------------------------------------|
| FSTToken      | 0x4d2a45556aa5951c8dd6885e87ecc74c0462e33b | FST Token 是流通货币 |
| FSTTokenAgentHolder| 0xd90ab0ee24ee3f6e376206f7b8cc7b13f8ef0c9c | 持有人锁仓合约   |

* 测试合约地址-测试 GUSD

|     Contract  |               Address                     |                Desc                     |
|:-----------   |:------------------------------------------|:----------------------------------------|
| FSTToken      | 0x9a8fe1459bf9f4979168b8f1ca7b5d161ccf5d68 | FST Token 是流通货币 |


* 测试合约地址-测试 USDT

|     Contract  |               Address                     |                Desc                     |
|:-----------   |:------------------------------------------|:----------------------------------------|
| FSTToken      | 0x309e2c4e95f735204bfa44f933fe4e88accafff7 | FST Token 是流通货币 |
| FSTTokenAgentHolder| 0xf5933a28ae9fcc5220dd7bd3375a8927d0f6212e | 持有人锁仓合约   |

* 主链合约地址

|     Contract  |               Address                     |                Desc                     |
|:-----------   |:------------------------------------------|:----------------------------------------|
| FSTToken      | 0x8171740C3f6631dA0496ca237e6ec7b9b94ed01E| FST Token 是流通货币 |
| FSTTokenAgentHolder| 0x65375171f109e90B9EA3e22F4734621857F13ea4| 持有人锁仓合约   |



