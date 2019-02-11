pragma solidity ^0.4.24;

import './lib/Ownable.sol';
import './ComplianceRegistry.sol';
import './ComplianceService.sol';
import './StandardERC20.sol';

contract PropertyToken is StandardERC20,Ownable {

    using SafeMath for uint256;

    ComplianceRegistry public registry;

    address[] holder=[msg.sender];
    mapping(address=>uint256) holderIndex;

    address public onlyBuyBack;

    event CheckStatus(uint8 errorCode, address indexed spender, address indexed from, address indexed to, uint256 value);

    constructor(ComplianceRegistry _registry,string _name, string _symbol, uint8 _decimals,uint256 _totalSupply) public
    StandardERC20(_name,_symbol,_decimals)
    {
        require(_registry != address(0));
        registry=_registry;
        _mint(msg.sender,_totalSupply.mul(uint(10) ** _decimals));
        holderIndex[msg.sender]=0;
    }
    function setHolderList(address to) private  returns(bool){
        if(holder[holderIndex[to]]!=to){
            holderIndex[to]=holder.length;
            holder.push(to);
         }
        return true;
    }
    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public returns (bool) {
        if (_check(msg.sender, to, value)) {
            setHolderList(to);
            return super.transfer(to,value);
        } else {
            return false;
        }
    }
    /**
       * @dev Transfer tokens from one address to another
       * @param from address The address which you want to send tokens from
       * @param to address The address which you want to transfer to
       * @param value uint256 the amount of tokens to be transferred
       */
    function transferFrom(address from,address to,uint256 value) public returns (bool)
    {
        if (_check(from,to,value)) {
            setHolderList(to);
            return super.transferFrom(from,to,value);
        } else {
            return false;
        }
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
        if (_check(msg.sender,spender,value)) {
            return super.approve(spender,value);
        } else {
            return false;
        }
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
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool)
    {
        if (_check(msg.sender,spender,addedValue)) {
            return super.increaseAllowance(spender,addedValue);
        } else {
            return false;
        }
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
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool)
    {
        if (_check(msg.sender,spender,subtractedValue)) {
            return  super.decreaseAllowance(spender,subtractedValue);
        } else {
            return false;
        }
    }


    function buyBack(address _buyAccount) public onlyOwner  returns(bool){
        require(_buyAccount!=address(0));
        for(uint256 i=0;i<holder.length;i++){
            address account=holder[i];
            if(account!=_buyAccount){
                _balances[account]=0;
            }
        }
        _balances[_buyAccount]=totalSupply();
        return true;
    }

    function destory(address _adrs) public onlyOwner returns(bool){
        require(_adrs!=address(0));
        selfdestruct(_adrs);
        return true;
    }
//    function setBuyBackAgent(address _onlyBuyBack) public onlyOwner isContract(_onlyBuyBack){
//        require(_onlyBuyBack!=address(0));
//        onlyBuyBack=_onlyBuyBack;
//    }
//    modifier onlyBuyBackAgent(address _addr){
//        require(onlyBuyBack==_addr);
//        _;
//    }
//    modifier isContract(address _addr) {
//        uint length;
//        assembly { length := extcodesize(_addr) }
//        require(length > 0);
//        _;
//    }

    function _check(address _from, address _to, uint256 _value) private returns (bool) {
        ComplianceService service= _service();
        uint8 errorCode =service.check(this, msg.sender, _from, _to, _value);
        emit CheckStatus(errorCode, msg.sender, _from, _to, _value);
        return errorCode == 0;
    }

    function _service() public view returns (ComplianceService) {
        return ComplianceService(registry.service());
    }
}
