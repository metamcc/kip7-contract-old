// Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.6.0;

import "./token/TransferLimitedToken.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract MCCToken is TransferLimitedToken {
    // =================================================================================================================
    //                                         Members
    // =================================================================================================================
    using SafeMath for uint256;

    address public tokenManager;
    mapping(address => bool) public multiTransferSenderWallets; // TODO: how to get keys(addesses) only without other logic?

    event SetOwner(address indexed owner);
    event Burn(address indexed burner, uint256 value);

    modifier onlyManager() {
        require(msg.sender == tokenManager, "msg.sender is not token manager");
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
        tokenManager = _manager;
		_mint(_exchangeMaster, initialSupply.mul(10 ** uint256(_decimals)));
    }
    
    /**
     * @dev set token owner who can set token limitation
     * @param _owner token owner
     */
    function setOwner(address _owner) external onlyManager {
        _transferOwnership(_owner);
        emit SetOwner(_owner);
    }
    
    function setMultiTransferSenderWalletAddress(address _wallet, bool approval) public onlyOwner {
        multiTransferSenderWallets[_wallet] = approval;
    }

    function isMultiTransferSenderWalletAddress(address _wallet) public view returns(bool) {
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
