# 合约介绍

##  PT Token
 
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
| renounceOwnership()    | 释放合约拥有权| 
| transferOwnership(address newOwner)    | 转让合约拥有权| 


#发行说明
按顺序发布以下合约

1.DefaultService Code.sol 
```
此合约无参数
```

2.Compliance Registry Code.sol 
```
此合约需要给DefaultService合约地址作为参数
```

PT Code.sol  
```
       名称         符号   精度  数量               注册服务合约地址
'TH000002 Token','TH000002',0,1000000000,'xxxxxxxxx'
```



# 合约地址
* 测试合约地址-测试(TH000001)

|     Contract  |               Address                     |                Desc                     |
|:-----------   |:------------------------------------------|:----------------------------------------|
| PropertyToken      | 0x050e97c062b066fb359abb2e786b20a70c7c64fd | PT Token 是流通货币 |
| DefaultService      | 0xa3b7613442cc86ef8d4a58456d6a297ca607f7ec | 服务 |
| ComplianceRegistry      | 0xa81cb61e2a0e57996d41443112b3b79c90fd929f |服务注册|

* 测试合约地址-测试(TH000002)

|     Contract  |               Address                     |                Desc                     |
|:-----------   |:------------------------------------------|:----------------------------------------|
| PropertyToken      | 0xa5c28aea274ca5a27a57689be78ccaa4710d7059 | PT Token 是流通货币 |
| DefaultService      | 0x76417370dd3eebded3c69eaf8d430ce0d7c2e791 | 服务 |
| ComplianceRegistry      | 0x7df2d8686dc8b104372922416e6eb5554faaa8a7 |服务注册|


