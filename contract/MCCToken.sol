// Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.6.0;

import "./token/TransferLimitedToken.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract MCCToken is TransferLimitedToken {
    // =================================================================================================================
    //                                         Members
    // =================================================================================================================
    using SafeMath for uint256;

    address private _tokenManager;
    address private _seedPublisher;

    mapping(address => bool) public multiTransferSenderWallets;

    event SetOwner(address indexed _owner);
    event SetSeedPublisher(address indexed _seedPublisher);
    event Goodmorn(uint256 _refKey, uint256 _from, uint256 _to, uint8 _seed, string _penalty, string _senderCountry, string _sendTime);

    modifier onlyManager() {
        require(msg.sender == _tokenManager, "msg.sender is not token manager");
        _;
    }
    
    modifier onlySeedPublisher() {
        require(msg.sender == _seedPublisher, "msg.sender is not seed publisher");
        _;
    }
    
    modifier canMultiTransfer(address _sender)  {
        require(multiTransferSenderWallets[_sender], "the sender address is not on multiTransferSenderWallets");
        require(!limitedSenderWallets[_sender], "the sender address is limited");
        _;
    }

    // =================================================================================================================
    //                                         Constructor
    // =================================================================================================================

    /**
     * @dev MCC Token
     */
    constructor(uint256 initialSupply, string memory _name, string memory _symbol, uint8 _decimals, address _exchangeMaster, address _owner, address _manager) public
        TransferLimitedToken(_name, _symbol, _decimals, _owner)
    {
        _tokenManager = _manager;
		_mint(_exchangeMaster, initialSupply.mul(10 ** uint256(_decimals)));
    }

    function () external payable {}
    
    function goodmorn(uint256 _refKey, uint256 _from, uint256 _to, uint8 _seed, string calldata _penalty, string calldata _senderCountry, string calldata _sendTime) onlySeedPublisher external payable {
        emit Goodmorn(_refKey, _from, _to, _seed, _penalty, _senderCountry, _sendTime);
    }
    
    function refund() external onlyOwner {
        _transfer(address(this), msg.sender, address(this).balance);
    }
    
    /**
     * @dev set token owner who can set token limitation
     * @param _owner: token owner
     */
    function setOwner(address _owner) external onlyManager returns (bool) {
        _transferOwnership(_owner);
        emit SetOwner(_owner);
        return true;
    }
    
    function manager() public view returns (address) {
        return _tokenManager;
    }
    
    /**
     * @dev set seed publisher who can set seed publisher
     * @param _publisher: seed publisher
     */
    function setSeedPublisher(address _publisher) external onlyOwner returns (bool) {
        _seedPublisher = _publisher;
        emit SetSeedPublisher(_publisher);
        return true;
    }

    function seedPublisher() public view returns (address) {
        return _seedPublisher;
    }
    
    /**
     * @dev set sender who who can use multiple transfer
     * @param _wallet: sender
     * @param _approval: true / false
     */
    function setMultiTransferSenderWalletAddress(address _wallet, bool _approval) public onlyOwner returns (bool) {
        multiTransferSenderWallets[_wallet] = _approval;
        return true;
    }

    function isMultiTransferSenderWalletAddress(address _wallet) public view returns (bool) {
        return multiTransferSenderWallets[_wallet];
    }

    /**
     * @dev transferMulti
     * @param _targets token receiver list
     * @param _values token amount to send
     */
    function transferMulti(address[] calldata _targets, uint256[] calldata _values) external transfersAllowed canMultiTransfer(msg.sender) {
        uint256 totalValues = 0;
        for ( uint i = 0 ; i < _targets.length ; i++ ) {
           require(!limitedReceiverWallets[_targets[i]], "the receiver address is limited");
           totalValues = totalValues.add(_values[i]);
           require(balanceOf(msg.sender) >= totalValues, "the sender doesn't have enough balance");
        }

        for( uint i = 0 ; i < _targets.length ; i++ ) {
		    transfer(_targets[i], _values[i]);
        }
     }
}
