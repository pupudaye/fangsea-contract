pragma solidity ^0.4.24;
import "./lib/Ownable.sol";
import "./StandardERC20.sol";
import "./lib/SafeMath.sol";

contract FSTTokenHolder is Ownable{

    using SafeMath for uint256;

    address public tokenAddress;

    uint256 public totalUnLockTokens;

    address public agentAddress;

    uint256 public globalLockPeriod;

    uint256 public unlockNum=4;
    mapping (address => HolderSchedule) public holderList;
    address[] public holderAccountList=[0];
    event ReleaseTokens(address indexed who,uint256 value);

    struct HolderSchedule {
        uint256 startAt;
        uint256 lockAmount;
        uint256 lockPeriod;
        uint256 releasedAmount;
        uint256 lastUnlocktime;
        bool isReleased;
    }

    constructor(address _tokenAddress ,uint256 _globalLockPeriod) public{
        tokenAddress=_tokenAddress;
        globalLockPeriod=_globalLockPeriod;
    }
    modifier onlyAgent() {
        require(agentAddress==msg.sender);
        _;
    }
    function setAgent(address _adr) public onlyOwner{
        require(_adr!=address(0));
        agentAddress=_adr;
    }
    function setHolder(address _adr,uint256 _lockAmount) public onlyAgent {
        HolderSchedule storage holderSchedule = holderList[_adr];
        require(_lockAmount > 0);
        StandardERC20 token = StandardERC20(tokenAddress);
        require(token.balanceOf(this) >= totalUnLockTokens.add(_lockAmount));
        holderSchedule.startAt = block.timestamp;
        holderSchedule.lastUnlocktime=holderSchedule.startAt;
        holderSchedule.lockPeriod = globalLockPeriod.add(holderSchedule.startAt);
        holderSchedule.lockAmount=holderSchedule.lockAmount.add(_lockAmount);
        holderSchedule.isReleased = false;
        holderSchedule.releasedAmount=0;
        holderAccountList[holderAccountList.length-1]=_adr;
    }


    function releaseMyTokens() public{
        releaseTokens(msg.sender);
    }

    function releaseTokens(address _adr) public{
        require(_adr!=address(0));
        //todo add holderList lockAmount check
        HolderSchedule storage holderSchedule = holderList[_adr];
        require(holderSchedule.lockAmount>0&&holderSchedule.isReleased==false);
        uint256 unlockAmount=lockStrategy(_adr);
        require(unlockAmount>0);
//        require(holderSchedule.lockAmount>=unlockAmount);
        holderSchedule.lockAmount=holderSchedule.lockAmount.sub(unlockAmount);
        holderSchedule.releasedAmount=holderSchedule.releasedAmount.add(unlockAmount);
        holderSchedule.lastUnlocktime=block.timestamp;
        if(holderSchedule.lockAmount==0){
            holderSchedule.isReleased=true;
        }
        StandardERC20 token = StandardERC20(tokenAddress);
        token.transfer(_adr,unlockAmount);
        emit ReleaseTokens(_adr,unlockAmount);
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
                    StandardERC20 token = StandardERC20(tokenAddress);
                    token.transfer(holderAccountList[i],unlockAmount);
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
