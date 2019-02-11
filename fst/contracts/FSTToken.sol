pragma solidity ^0.4.24;
import "./ERC20Capped.sol";

contract FSTToken is ERC20Capped {

    constructor(string name, string symbol, uint8 decimals,uint256 cap)
    public
    ERC20Capped(name,symbol,decimals,cap)
    {

    }

}
