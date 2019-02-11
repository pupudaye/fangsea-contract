pragma solidity ^0.4.24;

import './Ownable.sol';
contract MultiSign is Ownable{

    uint8 public min_signatures = 3;

    mapping (address => bool) private managers;

    struct EventRequest{

    }
    constructor(uint8 _min_signatures)public{
        min_signatures=_min_signatures;
    }
    modifier isManager{
        require(managers[msg.sender] ==true);
        _;
    }
    function addManager(address manager) public onlyOwner{
        managers[manager] = true;
    }
    function removeManager(address manager) public onlyOwner{
        managers[manager] = false;
    }

}
