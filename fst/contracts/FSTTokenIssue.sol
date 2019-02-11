pragma solidity ^0.4.24;
import "./lib/Ownable.sol";
import "./lib/SafeMath.sol";
import './FSTToken.sol';
import './FSTTokenHolder.sol';

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
