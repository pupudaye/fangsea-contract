pragma solidity ^0.4.24;

import './lib/Ownable.sol';

contract ComplianceRegistry is Ownable{

    address public service;

    event ChangeService(address _old, address _new);

    constructor(address _service) public {
        service = _service;
    }

    modifier isContract(address _addr) {
        uint length;
        assembly { length := extcodesize(_addr) }
        require(length > 0);
        _;
    }

    function changeService(address _service) onlyOwner isContract(_service) public {
        address old = service;
        service = _service;
        emit ChangeService(old, service);
    }
}
