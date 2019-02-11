pragma solidity ^0.4.24;

import "./ERC20Mintable.sol";

/**
 * @title Capped token
 * @dev Mintable token with a token cap.
 */
contract ERC20Capped is ERC20Mintable {

    uint256 private _cap;

    constructor(string name, string symbol, uint8 decimals,uint256 cap)
    public
    ERC20Mintable(name,symbol,decimals)
    {
        require(cap > 0);
        _cap =  cap.mul(uint(10) **decimals);
    }

    /**
     * @return the cap for the token minting.
     */
    function cap() public view returns(uint256) {
        return _cap;
    }

    function _mint(address account, uint256 value) internal {
        require(totalSupply().add(value) <= _cap);
        super._mint(account, value);
    }
}
