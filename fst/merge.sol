pragma solidity ^0.4.24;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev give an account access to this role
     */
    function add(Role storage role, address account) internal {
        require(account != address(0));
        require(!has(role, account));

        role.bearer[account] = true;
    }

    /**
     * @dev remove an account's access to this role
     */
    function remove(Role storage role, address account) internal {
        require(account != address(0));
        require(has(role, account));

        role.bearer[account] = false;
    }

    /**
     * @dev check if an account has this role
     * @return bool
     */
    function has(Role storage role, address account)
    internal
    view
    returns (bool)
    {
        require(account != address(0));
        return role.bearer[account];
    }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender)
    external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value)
    external returns (bool);

    function transferFrom(address from, address to, uint256 value)
    external returns (bool);

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param owner The address to query the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(
        address owner,
        address spender
    )
    public
    view
    returns (uint256)
    {
        return _allowed[owner][spender];
    }

    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    )
    public
    returns (bool)
    {
        require(value <= _allowed[from][msg.sender]);

        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        _transfer(from, to, value);
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(
        address spender,
        uint256 addedValue
    )
    public
    returns (bool)
    {
        require(spender != address(0));

        _allowed[msg.sender][spender] = (
        _allowed[msg.sender][spender].add(addedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    )
    public
    returns (bool)
    {
        require(spender != address(0));

        _allowed[msg.sender][spender] = (
        _allowed[msg.sender][spender].sub(subtractedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Transfer token for a specified addresses
    * @param from The address to transfer from.
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function _transfer(address from, address to, uint256 value) internal {
        require(value <= _balances[from]);
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param value The amount that will be created.
     */
    function _mint(address account, uint256 value) internal {
        require(account != 0);
        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != 0);
        require(value <= _balances[account]);

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        require(value <= _allowed[account][msg.sender]);

        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
        // this function needs to emit an event with the updated approval.
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
            value);
        _burn(account, value);
    }
}


contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private minters;

    constructor() internal {
        _addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(isMinter(msg.sender));
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(msg.sender);
    }

    function _addMinter(address account) internal {
        minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        minters.remove(account);
        emit MinterRemoved(account);
    }
}

/**
 * @title ERC20Mintable
 * @dev ERC20 minting logic
 */
contract ERC20Mintable is ERC20, MinterRole {
    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param value The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(
        address to,
        uint256 value
    )
    public
    onlyMinter
    returns (bool)
    {
        _mint(to, value);
        return true;
    }
}
/**
 * @title Capped token
 * @dev Mintable token with a token cap.
 */
contract ERC20Capped is ERC20Mintable {

    uint256 private _cap;

    constructor(uint256 cap)
    public
    {
        require(cap > 0);
        _cap = cap;
    }

    /**
     * @return the cap for the token minting.
     */
    function cap() public view returns(uint256) {
        return _cap;
    }

    function _mint(address account, uint256 value) internal {
        require(totalSupply().add(value) <= _cap);
        super._mint(account, value);
    }
}
/**
 * @title ERC20Detailed token
 * @dev The decimals are only for visualization purposes.
 * All the operations are done using the smallest and indivisible token unit,
 * just as on Ethereum all the operations are done in wei.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(string name, string symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @return the name of the token.
     */
    function name() public view returns(string) {
        return _name;
    }

    /**
     * @return the symbol of the token.
     */
    function symbol() public view returns(string) {
        return _symbol;
    }

    /**
     * @return the number of decimals of the token.
     */
    function decimals() public view returns(uint8) {
        return _decimals;
    }
}
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns(address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns(bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
contract FSTToken is ERC20Capped,ERC20Detailed {

    constructor(string name, string symbol, uint8 decimals,uint256 cap)
    public
    ERC20Capped(cap.mul(uint(10) **decimals))
    ERC20Detailed(name,symbol,decimals)
    {

    }

}
contract FSTTokenIssue is Ownable{

    using SafeMath for uint256;

    address public tokenAddress;
    address public fSTTokenHolderAddress;

    uint256 public price;

    mapping (address => bool ) public OWhitelist;
    mapping (address => uint256 ) public TWhitelist;
    //    Team[10] public TWhitelist;

    uint256 public OMaxAmount;
    uint256 public OSoldAmount;

    FSTToken private fSTToken;
    FSTTokenHolder private fSTTokenHolder;
    event Buy(address indexed who,uint256 value);

    //    struct Team{
    //        address teamAccount;
    //        uint256 bonusAmount;
    //    }
    constructor(
        address _tokenAddress,
        uint256 _price,
        uint256 _OMaxAmount,
        address _fSTTokenHolderAddress
    )public {
        tokenAddress=_tokenAddress;
        price=_price;
        OMaxAmount=_OMaxAmount;
        fSTTokenHolderAddress=_fSTTokenHolderAddress;
        fSTToken=FSTToken(tokenAddress);
        fSTTokenHolder=FSTTokenHolder(fSTTokenHolderAddress);
    }

    function setOWhitelist(address[] _accountAddress) public onlyOwner{
        require(_accountAddress.length > 0);
        uint256 _accountAddressCount = _accountAddress.length;
        for (uint256 j=0; j<_accountAddressCount; j++) {
            require(_accountAddress[j] != 0);
            OWhitelist[_accountAddress[j]] = true;
        }
    }
    function removeOWhitelist(address _accountAddress)public onlyOwner{
        require(OWhitelist[_accountAddress]);
        OWhitelist[_accountAddress]=false;
    }
    //    uint256 public testV;
    function setTWhitelist(address[] _tWhitelistAccount,uint256[] _tWhitelistAmount) public onlyOwner{
        require(_tWhitelistAccount.length ==_tWhitelistAmount.length);
        uint256 _tWhitelistCount = _tWhitelistAccount.length;
        for (uint256 i=0; i<_tWhitelistCount; i++) {
            require(_tWhitelistAccount[i] != address(0));
            require(_tWhitelistAmount[i] >0);
            TWhitelist[_tWhitelistAccount[i]]=_tWhitelistAmount[i].mul(uint(10) **fSTToken.decimals());
            //            testV= TWhitelist[_tWhitelistAccount[i]];
            //            break;
        }
    }

    //    function setTWhitelist(address[] _tWhitelistAccount,uint256[] _tWhitelistAmount) public onlyOwner{
    //        require(_tWhitelistAccount.length ==_tWhitelistAmount.length);
    //        uint256 _tWhitelistCount = _tWhitelistAccount.length;
    //        uint256 twCount=TWhitelist.length;
    //        for (uint256 i=0; i<_tWhitelistCount; i++) {
    //            require(_tWhitelistAccount[i] != address(0));
    //            require(_tWhitelistAmount[i] >0);
    //            uint256 index= i.add(twCount);
    //            TWhitelist[index].teamAccount=_tWhitelistAccount[i];
    //            TWhitelist[index].bonusAmount=_tWhitelistAmount[i].mul(uint(10) **fSTToken.decimals());
    //        }
    //    }
    function removeTWhitelist(address _adr) public onlyOwner{
        require(_adr!=address(0));
        TWhitelist[_adr]=0;
    }
    //    function removeTWhitelist(address _accountAddress) public onlyOwner{
    //        require(_accountAddress!=address(0));
    //        uint256 teamCount = TWhitelist.length;
    //        for (uint256 i=0; i<teamCount; i++) {
    //            if(TWhitelist[i].teamAccount==_accountAddress){
    //                TWhitelist[i].bonusAmount=0;
    //                break;
    //            }
    //        }
    //    }

    function  provideTeamHolderToken(address _adr) public onlyOwner{
        require(_adr != address(0));
        require(TWhitelist[_adr]>0);
        accessToken(fSTTokenHolderAddress,TWhitelist[_adr]);
        fSTTokenHolder.setHolder(_adr,TWhitelist[_adr]);
    }
    function() payable public {
        _invest(msg.sender);
    }

    function buy() public payable {
        _invest(msg.sender);
    }

    function _invest(address _adr) internal {
        require(_adr != address(0));
        require(OWhitelist[_adr]);
        require(price>0);
        uint256 weiAmount = msg.value;
        uint256 tokenAmount=weiAmount.div(price);
        require(tokenAmount>0);
        require(OSoldAmount.add(tokenAmount)<=OMaxAmount);
        OSoldAmount=OSoldAmount.add(tokenAmount);
        uint256 totalAmount=tokenAmount.mul(uint(10) **fSTToken.decimals());
        accessToken(fSTTokenHolderAddress,totalAmount);
        fSTTokenHolder.setHolder(_adr,totalAmount);
        emit Buy(_adr,tokenAmount);
    }
    function accessToken(address rec,uint256 value)private {
        fSTToken.mint(rec,value);
    }

    function destory(address _adrs) public onlyOwner returns(bool){
        require(_adrs!=address(0));
        selfdestruct(_adrs);
        return true;
    }
}
contract FSTTokenHolder is Ownable{

    using SafeMath for uint256;

    address public tokenAddress;

    uint256 public totalUnLockTokens;

    address public agentAddress;

    uint256 public globalLockPeriod;

    uint256 public unlockNum=8;
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
        ERC20 token = ERC20(tokenAddress);
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
        ERC20 token = ERC20(tokenAddress);
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
                    ERC20 token = ERC20(tokenAddress);
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

