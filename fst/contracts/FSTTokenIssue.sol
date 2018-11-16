pragma solidity ^0.4.24;
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
import './FSTToken.sol';
import './FSTTokenHolder.sol';

contract FSTTokenIssue is Ownable{

    using SafeMath for uint256;

    address public tokenAddress;
    address public fSTTokenHolderAddress;

    uint256 public price;

    mapping (address => bool ) public OWhitelist;
//    mapping (address => uint256 ) public TWhitelist;
    Team[10] public TWhitelist;

    uint256 public OMaxAmount;
    uint256 public OSoldAmount;

    FSTToken private fSTToken;
    FSTTokenHolder private fSTTokenHolder;
    event Buy(address indexed who,uint256 value);

    struct Team{
        address teamAccount;
        uint256 bonusAmount;
    }
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

    function setTWhitelist(address[] _tWhitelistAccount,uint256[] _tWhitelistAmount) public onlyOwner{
        require(_tWhitelistAccount.length ==_tWhitelistAmount.length);
        uint256 _tWhitelistCount = _tWhitelistAccount.length;
        for (uint256 i=0; i<_tWhitelistCount; i++) {
            require(_tWhitelistAccount[i] != address(0));
            require(_tWhitelistAmount[i] >0);
            TWhitelist[i].teamAccount=_tWhitelistAccount[i];
            TWhitelist[i].bonusAmount=_tWhitelistAmount[i];
        }
    }

    function removeTWhitelist(address _accountAddress) public onlyOwner{
        require(_accountAddress!=address(0));
        uint256 teamCount = TWhitelist.length;
        for (uint256 i=0; i<teamCount; i++) {
            if(TWhitelist[i].teamAccount==_accountAddress){
                TWhitelist[i].bonusAmount=0;
                break;
            }
        }
    }

    function  provideTeamHolderToken() public onlyOwner{
        require(TWhitelist.length>0);
        uint256 teamCount = TWhitelist.length;
        for (uint256 i=0; i<teamCount; i++) {
            if(TWhitelist[i].bonusAmount > 0){
                accessToken(fSTTokenHolderAddress,TWhitelist[i].bonusAmount);
                fSTTokenHolder.setHolder(TWhitelist[i].teamAccount,TWhitelist[i].bonusAmount);
            }
        }
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
        accessToken(fSTTokenHolderAddress,tokenAmount);
        fSTTokenHolder.setHolder(_adr,tokenAmount);
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
