pragma solidity ^0.4.24;
import "./lib/Ownable.sol";
contract Holder is Ownable{

    address private agentHolder;

    uint256 public totalLockTokens;

    uint256 public totalUNLockTokens;

    uint256 public globalLockPeriod;

    uint256 public unlockNum=4;

    mapping (address => HolderSchedule) public holderList;

    address[] public holderAccountList=[0x0];

    struct HolderSchedule {
        uint256 startAt;
        uint256 lockAmount;
        uint256 releasedAmount;
        uint256 lastUnlocktime;
        bool isReleased;
    }

    constructor(uint256 _globalLockPeriod,uint256 _unlockNum) public{
        globalLockPeriod=_globalLockPeriod;
        unlockNum=_unlockNum;
    }
    function setAgentHolder(address _agentHolder)public onlyOwner{
        agentHolder=_agentHolder;
    }
    /**
 * @return the address of the owner.
 */
    function agentHolder() public view returns(address) {
        return agentHolder;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyAgentHolder() {
        require(agentHolder());
        _;
    }

    function setTotalLockTokens(uint256 _totalLockTokens) public onlyAgentHolder{
        totalLockTokens=_totalLockTokens;
    }
    function setTotalUNLockTokens(uint256 _totalUNLockTokens) public onlyAgentHolder{
        totalUNLockTokens=_totalUNLockTokens;
    }
}
