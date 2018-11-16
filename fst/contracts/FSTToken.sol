pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol';
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol';

contract FSTToken is ERC20Capped,ERC20Detailed {

    constructor(string name, string symbol, uint8 decimals,uint256 cap)
    public
    ERC20Capped(cap)
    ERC20Detailed(name,symbol,decimals)
    {

    }

}
