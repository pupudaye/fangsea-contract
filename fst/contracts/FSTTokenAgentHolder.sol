pragma solidity ^0.4.24;
import "./lib/Ownable.sol";
import "./FSTToken.sol";
import "./lib/SafeMath.sol";

contract FSTTokenAgentHolder is Ownable{

    using SafeMath for uint256;

    FSTToken private token ;

    uint256 public totalLockTokens;

    uint256 public totalUNLockTokens;
    uint256 public globalLockPeriod;

    uint256 public unlockNum=4;
    mapping (address => HolderSchedule) public holderList;
    address[] public holderAccountList=[0];
    event ReleaseTokens(address indexed who,uint256 value);
    event HolderToken(address indexed who,uint256 value,uint256 totalValue);

    struct HolderSchedule {
        uint256 startAt;
        uint256 lockAmount;
        uint256 releasedAmount;
        uint256 lastUnlocktime;
        bool isReleased;
    }

    constructor(address _tokenAddress ,uint256 _globalLockPeriod,uint256 _unlockNum) public{
        token = FSTToken(_tokenAddress);
        globalLockPeriod=_globalLockPeriod;
        unlockNum=_unlockNum;
    }
    function holderSurplusTime(address _adr)public view returns(uint256) {
        HolderSchedule memory holderSchedule = holderList[_adr];
        uint256 interval=block.timestamp.sub(holderSchedule.lastUnlocktime);
        uint256 timeNode=globalLockPeriod.div(unlockNum);
        uint256 mulNum=0;
        if(interval>=timeNode){
            mulNum=interval.div(timeNode);
        }
        return mulNum;
    }
    function addHolderToken(address _adr,uint256 _lockAmount) public onlyOwner {
        HolderSchedule storage holderSchedule = holderList[_adr];
        require(_lockAmount > 0);
        _lockAmount=_lockAmount.mul(uint(10) **token.decimals());
        if(holderSchedule.lockAmount==0){
            holderSchedule.startAt = block.timestamp;
            holderSchedule.lastUnlocktime=holderSchedule.startAt;
            holderSchedule.releasedAmount=0;
            holderSchedule.isReleased = false;
            holderAccountList[holderAccountList.length-1]=_adr;
        }
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
            //        require(holderSchedule.lockAmount>0&&holderSchedule.isReleased==false);
            uint256 unlockAmount=lockStrategy(_adr);
            //        require(unlockAmount>0);
            //        require(holderSchedule.lockAmount>=unlockAmount);
            if(unlockAmount>0&&holderSchedule.lockAmount>=unlockAmount){
                holderSchedule.lockAmount=holderSchedule.lockAmount.sub(unlockAmount);
                holderSchedule.releasedAmount=holderSchedule.releasedAmount.add(unlockAmount);
                holderSchedule.lastUnlocktime=block.timestamp;
                if(holderSchedule.lockAmount==0){
                    holderSchedule.isReleased=true;
                }
                accessToken(_adr,unlockAmount);
                emit ReleaseTokens(_adr,unlockAmount);
            }
        }
    }
    function releaseEachTokens() public {
        require(holderAccountList.length>0);
        for(uint i=0;i<holderAccountList.length;i++){
            HolderSchedule storage holderSchedule = holderList[holderAccountList[i]];
            if(holderSchedule.lockAmount>0&&holderSchedule.isReleased==false){
                uint256 unlockAmount=lockStrategy(holderAccountList[i]);
                if(unlockAmount>0){
                    holderSchedule.lockAmount=holderSchedule.lockAmount.sub(unlockAmount);
                    holderSchedule.releasedAmount=holderSchedule.releasedAmount.add(unlockAmount);
                    holderSchedule.lastUnlocktime=block.timestamp;
                    if(holderSchedule.lockAmount==0){
                        holderSchedule.isReleased=true;
                    }
                    accessToken(holderAccountList[i],unlockAmount);
                }
            }
        }
    }
    function lockStrategy(address _adr) private view returns(uint256){
        HolderSchedule memory holderSchedule = holderList[_adr];
        uint256 interval=block.timestamp.sub(holderSchedule.lastUnlocktime);
        uint256 timeNode=globalLockPeriod.div(unlockNum);
        uint256 unlockAmount=0;
        if(interval>=timeNode){
            uint256 mulNum=interval.div(timeNode);
            uint totalAmount=holderSchedule.lockAmount.add(holderSchedule.releasedAmount);
            uint singleAmount=totalAmount.div(unlockNum);
            unlockAmount=singleAmount.mul(mulNum);
            if(unlockAmount>holderSchedule.lockAmount){
                unlockAmount=holderSchedule.lockAmount;
            }
        }
        return unlockAmount;
    }
    function destory(address _adrs) public onlyOwner returns(bool){
        require(_adrs!=address(0));
        selfdestruct(_adrs);
        return true;
    }
}
