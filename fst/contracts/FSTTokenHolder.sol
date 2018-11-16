pragma solidity ^0.4.24;
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract FSTTokenHolder is Ownable{

    using SafeMath for uint256;

    address public tokenAddress;

    uint256 public totalUnLockTokens;

    address public agentAddress;

    uint256 public globalLockPeriod;

    uint256 public unlockNum=8;
    mapping (address => HolderSchedule) public holderList;

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
        ERC20 token = ERC20(tokenAddress);
        require(token.balanceOf(this) >= totalUnLockTokens.add(_lockAmount));
        holderSchedule.startAt = block.timestamp;
        holderSchedule.lastUnlocktime=holderSchedule.startAt;
        holderSchedule.lockPeriod = globalLockPeriod.add(holderSchedule.startAt);
        holderSchedule.lockAmount=_lockAmount;
        holderSchedule.isReleased = false;
        holderSchedule.releasedAmount=0;
    }


    function releaseMyTokens() public{
        releaseTokens(msg.sender);
    }

    function releaseTokens(address _adr) public{
        require(_adr!=address(0));
        uint256 unlockAmount=lockStrategy(_adr);
        require(unlockAmount>0);
//        if(unlockAmount>0){
            HolderSchedule storage holderSchedule = holderList[_adr];
            require(holderSchedule.lockAmount>=unlockAmount);
            holderSchedule.lockAmount=holderSchedule.lockAmount.sub(unlockAmount);
            holderSchedule.releasedAmount=holderSchedule.releasedAmount.add(unlockAmount);
            holderSchedule.lastUnlocktime=block.timestamp;
            ERC20 token = ERC20(tokenAddress);
            token.transfer(_adr,unlockAmount);
//        }
        emit ReleaseTokens(_adr,unlockAmount);
    }
    function lockStrategy(address _adr) private view returns(uint256){
        HolderSchedule memory holderSchedule = holderList[_adr];
        uint256 interval=block.timestamp.sub(holderSchedule.lastUnlocktime);
        uint256 timeNode=globalLockPeriod.div(unlockNum);
        require(interval>=timeNode);
        uint256 mulNum=interval.div(timeNode);
        uint totalAmount=holderSchedule.lockAmount.add(holderSchedule.releasedAmount);
        uint singleAmount=totalAmount.div(unlockNum);
        uint256 unlockAmount=singleAmount.mul(mulNum);
        if(unlockAmount>holderSchedule.lockAmount){
            unlockAmount=holderSchedule.lockAmount;
        }
        return unlockAmount;
    }
    function destory(address _adrs) public onlyOwner returns(bool){
        require(_adrs!=address(0));
        selfdestruct(_adrs);
        return true;
    }
}
