pragma solidity ^0.4.24;

import './lib/Ownable.sol';
contract GlobalWhitelist is Ownable {

    mapping(address => string) public countryCode;// 国家代码
    mapping(address => bool) public canTrust;//是否可信任
    mapping(address => bool) public canSendToken;//是否可发送交易
    mapping(address => bool) public canReceiveToken;//是否可接受交易

    function setWhitelist(address _account,string _countryCode,bool _canTrust,bool _canSendToken,bool _canReceiveToken)public onlyOwner returns(bool){
        require(_account!=address(0));
        countryCode[_account]=_countryCode;
        canTrust[_account]=_canTrust;
        canSendToken[_account]=_canSendToken;
        canReceiveToken[_account]=_canReceiveToken;
        return true;
    }

    function changeTrust(address _account,bool _canTrust) public onlyOwner returns(bool) {
        require(_account!=address(0));
        canTrust[_account]=_canTrust;
        return true;
    }
    function changeCanSend(address _account,bool _canSendToken) public onlyOwner returns(bool) {
        require(_account!=address(0));
        canSendToken[_account]=_canSendToken;
        return true;
    }
    function changeCanReceive(address _account,bool _canReceiveToken) public onlyOwner returns(bool) {
        require(_account!=address(0));
        canReceiveToken[_account]=_canReceiveToken;
        return true;
    }

}
