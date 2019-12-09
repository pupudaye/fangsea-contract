pragma solidity ^0.4.24;
import "./lib/Ownable.sol";
import "./FSTToken.sol";
import "./lib/SafeMath.sol";


contract FSTTokenTeamAgentHolder is Ownable{

    using SafeMath for uint256;

    using SafeMath for uint8;

    FSTToken private token ;

    uint256 public totalLockTokens;

    uint256 public totalUNLockTokens;
    uint256 public globalLockPeriod;

    uint[] public stageRatios=[10,20,30,40];

    mapping (address => HolderSchedule) public holderList;
    address[] public holderAccountList=[0x0];

    uint256 private singleNodeTime;

    event ReleaseTokens(address indexed who,uint256 value);
    event HolderToken(address indexed who,uint256 value,uint256 totalValue);

    struct HolderSchedule {
        uint256 startAt;
        uint256 lockAmount;
        uint256 releasedAmount;
        uint256 totalReleasedAmount;
        uint256 lastUnlocktime;
        bool isReleased;
        bool isInvested;
        uint256 unlockNumed;
    }

    constructor(address _tokenAddress ,uint256 _globalLockPeriod,uint[] _stageRatios) public{
        token = FSTToken(_tokenAddress);
        globalLockPeriod=_globalLockPeriod;
        stageRatios=_stageRatios;
        singleNodeTime=globalLockPeriod.div(stageRatios.length);
    }

    function addHolderToken(address _adr,uint256 _lockAmount) public onlyOwner {
        HolderSchedule storage holderSchedule = holderList[_adr];
        require(_lockAmount > 0);
        _lockAmount=_lockAmount.mul(uint(10) **token.decimals());
        if(holderSchedule.isInvested==false||holderSchedule.isReleased==true){
            holderSchedule.isInvested=true;
            holderSchedule.startAt = block.timestamp;
            holderSchedule.lastUnlocktime=holderSchedule.startAt;
            if(holderSchedule.isReleased==false){
                holderSchedule.releasedAmount=0;
                if(holderAccountList[0]==0x0){
                    holderAccountList[0]=_adr;
                }else{
                    holderAccountList.push(_adr);
                }
            }
        }
        holderSchedule.isReleased = false;
        holderSchedule.lockAmount=holderSchedule.lockAmount.add(_lockAmount);
        totalLockTokens=totalLockTokens.add(_lockAmount);
        emit HolderToken(_adr,_lockAmount,holderSchedule.lockAmount.add(holderSchedule.releasedAmount));
    }

    function subHolderToken(address _adr,uint256 _lockAmount)public onlyOwner{
        HolderSchedule storage holderSchedule = holderList[_adr];
        require(_lockAmount > 0);
        _lockAmount=_lockAmount.mul(uint(10) **token.decimals());
        require(holderSchedule.lockAmount>=_lockAmount);
        holderSchedule.lockAmount=holderSchedule.lockAmount.sub(_lockAmount);
        totalLockTokens=totalLockTokens.sub(_lockAmount);
        emit HolderToken(_adr,_lockAmount,holderSchedule.lockAmount.add(holderSchedule.releasedAmount));
    }

    function accessToken(address rec,uint256 value) private {
        totalUNLockTokens=totalUNLockTokens.add(value);
        token.mint(rec,value);
    }
    function releaseMyTokens() public{
        releaseTokens(msg.sender);
    }

    function releaseTokens(address _adr) public{
        require(_adr!=address(0));
        HolderSchedule storage holderSchedule = holderList[_adr];
        if(holderSchedule.isReleased==false&&holderSchedule.lockAmount>0){
            uint256 timestamp=block.timestamp;
            uint256 unlockNum=hasUnlockNum(_adr,timestamp);
            if(unlockNum>0){
                uint256 unlockAmount=hasUnlockAmount(_adr,unlockNum);
                if(unlockAmount>0&&holderSchedule.lockAmount>=unlockAmount){
                    holderSchedule.lockAmount=holderSchedule.lockAmount.sub(unlockAmount);
                    holderSchedule.releasedAmount=holderSchedule.releasedAmount.add(unlockAmount);
                    holderSchedule.totalReleasedAmount=holderSchedule.totalReleasedAmount.add(unlockAmount);
                    holderSchedule.lastUnlocktime=timestamp;
                    holderSchedule.unlockNumed=unlockNum;
                    if(holderSchedule.lockAmount==0){
                        holderSchedule.isReleased=true;
                        holderSchedule.releasedAmount=0;
                        holderSchedule.unlockNumed=0;
                    }
                    accessToken(_adr,unlockAmount);
                    emit ReleaseTokens(_adr,unlockAmount);
                }
            }
        }
    }

    function hasUnlockNum(address _adr,uint256 timestamp) public view returns(uint256){
        HolderSchedule storage holderSchedule = holderList[_adr];
        uint256 interval=timestamp.sub(holderSchedule.startAt);
        uint256 unlockNum=0;
        if(interval>=singleNodeTime){
            unlockNum=interval.div(singleNodeTime);
        }
        if(unlockNum>stageRatios.length)
        {
            unlockNum=stageRatios.length;
        }
        return unlockNum;
    }

    function hasUnlockAmount(address _adr,uint256 unlockNum) public view returns(uint256){
        HolderSchedule storage holderSchedule = holderList[_adr];
        uint256 unlockAmount=0;
        uint totalAmount=holderSchedule.lockAmount.add(holderSchedule.releasedAmount);
        uint totalRatio=0;
        if(unlockNum<=stageRatios.length){
            for(uint i=0;i<unlockNum;i++){
                totalRatio=totalRatio.add(stageRatios[i]);
            }
        }
        uint256 singleAmount=totalAmount.div(100);
        uint256 unlockTotalAmount=singleAmount.mul(totalRatio);
        unlockAmount=unlockTotalAmount.sub(holderSchedule.releasedAmount);
        if(unlockAmount>holderSchedule.lockAmount){
            unlockAmount=holderSchedule.lockAmount;
        }
        return unlockAmount;
    }
}
