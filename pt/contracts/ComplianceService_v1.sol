pragma solidity ^0.4.24;
import "./lib/SafeMath.sol";
import './lib/Ownable.sol';
import './ComplianceService.sol';
import './GlobalWhitelist.sol';
contract ComplianceService_v1 is ComplianceService, Ownable {

    using SafeMath for uint256;

    GlobalWhitelist private globalWhitelist;

    bool public canTransferDecimal=false;
    uint256 private integer=1000000000000000000;

    LockSchedule public lockSchedule=LockSchedule({lock:false,startTime:0,lockTime:0});

    struct LockSchedule{
        bool lock;
        uint256 startTime;
        uint256 lockTime;
    }

    uint8[] private errorCode=[
    0,//success
    100,//status is lock
    101,//_spender not is Whitelist
    102,//_from not is Whitelist
    103,//_from not allow canSendToken
    104,//_to not is Whitelist
    105,//_to not allow canReceiveToken
    106 //Not allow Transfer Decimal PT
    ];

    constructor(address _globalWhitelist)public{
        globalWhitelist=GlobalWhitelist(_globalWhitelist);
    }

    function check(address _token,address _spender,address _from,address _to,uint256 _amount) public view returns (uint8){
        require(_token!=address(0));
        require(_spender!=address(0));
        require(_from!=address(0));
        require(_to!=address(0));
        require(_amount>0);
        uint256 interval=block.timestamp.sub(lockSchedule.startTime);
        if(lockSchedule.lock&&interval>=lockSchedule.lockTime){
            return errorCode[1];
        }

        if(globalWhitelist.canTrust(_spender)==false){
             return errorCode[2];
        }
        if(globalWhitelist.canTrust(_from)==false){
            return errorCode[3];
        }
        if(globalWhitelist.canTrust(_from)==true&&globalWhitelist.canSendToken(_from)==false){
             return errorCode[4];
        }
        if(globalWhitelist.canTrust(_to)==false){
             return errorCode[5];
        }
        if(globalWhitelist.canTrust(_to)==true&&globalWhitelist.canReceiveToken(_to)==false){
            return errorCode[6];
        }
        if(!canTransferDecimal&&(_amount%integer)!=0){
            return errorCode[7];
        }
        return 0;
    }

    function setCanTransferDecimal(bool _canTransferDecimal)public onlyOwner returns(bool){
        canTransferDecimal=_canTransferDecimal;
        return true;
    }

    function setLock(bool _lock,uint256 _lockTime)public onlyOwner returns(bool){
        lockSchedule.lock=_lock;
        lockSchedule.startTime=block.timestamp;
        lockSchedule.lockTime=_lockTime;
        return true;
    }
}
