
# 合约地址
* 测试链合约地址

|     Contract  |               Address                     |                Desc                     |  
|:-----------   |:------------------------------------------|:----------------------------------------| 
| FSTToken      | 0x93842259b30ea9a84eefcd8819ae154c753abe03| FST Token 是流通货币 |
| FSTTokenHolder| 0xb03f0a9156544a83b3dedd532f71cc777d4f5d38| 持有人锁仓合约   |
| FSTTokenIssue | 0x72f8f65cc4a3f037a212a7fb8c612c345b64637d| 融资合约    |

* 主链链合约地址

|     Contract  |               Address                     |                Desc                     |  
|:-----------   |:------------------------------------------|:----------------------------------------| 
| FSTToken      | -| FST Token 是流通货币 |
| FSTTokenHolder| -| 持有人锁仓合约   |
| FSTTokenIssue | -| 融资合约    |

#  测试方案模型
* 测试人数4人,同时担任机构投资和团队成员
* FST发行总额100000
* 测试锁仓总长时间10分钟，分为8个解锁阶段，每个阶段75秒，解锁额度为投资/奖励额度的八分之一
* 正常测试步骤
   1. 发布合约到测试链(已完成)
   2. 设置铸币权限为融资合约地址(已完成)
   3. 设置注入锁仓队列权限为融资合约地址(已完成)
   4. 每个测试人提供两个钱包地址，一个为机构账户，一个为团队账户
   5. 设置机构白名单，4位测试人可以约定好投资额度
   6. 设置团队白名单和奖励额度
   7. 机构投资人可向融资合约地址转账ETH，注意不要超过约定额度 避免超过总投资额度限制
   8. 机构投资完成后融资合约拥有者可以开始进行团队奖励发放
   9. 投资人和团队成员可根据时间到期解锁FST，总共有8次，也可以等待10分钟完成一次性提取
* 测试方法采用浏览器打开etherscan 和 metamask
   1. 利用metamask向融资合约地址转账ETH，等待交易完成
   2. 打开锁仓合约地址：https://ropsten.etherscan.io/address/0xb03f0a9156544a83b3dedd532f71cc777d4f5d38
   3. 进入Read Contract选项卡 在 holderList 位置输入自己的钱包地址查询锁仓额度
   4. 当时间到达75秒或达到75秒的倍数时可以切换到Write Contract选项卡，在 releaseMyTokens或者releaseTokens位置解锁FST额度
   5. 解锁完成后打开FSTToken合约地址：https://ropsten.etherscan.io/address/0x93842259b30ea9a84eefcd8819ae154c753abe03
   6. 进入Read Contract选项卡 在 balanceOf 位置处 输入自己的钱包地址查询FST额度
   
* 注意： 非正常测试步骤的测试，可以等到完成后进行审查。


# 开发环境
1. webstorm v2018.1.4 
2. nodejs v8.9.3
3. npm v5.5.1
4. truffle v4.1.14
5. solidity v0.4.24

# 安装:
* 初始化项目

```
npm init -y
```
* 安装代币合约支持包 openzeppelin-solidity

```
npm install --save-exact openzeppelin-solidity
```
* windows下面需要先安装

```
npm install -g windows-build-tools
```
* 安装部署支持包truffle-hdwallet-provider

```
npm install truffle-hdwallet-provider
```

# 客户端:
* ganache-cli模式

```
ganache-cli -p 8545
```
* develop模式(默认端口:9545)

```
truffle.cmd develop  
```

# 测试:
* ganache-cli 模式

```
truffle.cmd test
```
* develop模式

```
test
```
#  发布
* ropsten

```
truffle.cmd migrate --network ropsten
```
* main

```
truffle.cmd migrate --network main
```

# QA/FAQ
* 发布测试链或主链如何发布源码检查?
