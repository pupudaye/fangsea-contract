pragma solidity ^0.4.24;

contract ComplianceService {

    function check(address _token,address _spender,address _from,address _to,uint256 _amount) public view returns (uint8);

}
