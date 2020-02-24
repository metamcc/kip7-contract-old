// Klaytn IDE uses solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.6.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

/**
 * @title ManagedToken
 * @dev ERC20 compatible token with issue and destroy facilities
 * @dev All transfers can be monitored by token event listener
 */
contract ManagedToken is ERC20, ERC20Detailed, Ownable {
    bool private _allowTransfer = false;

    event AllowTransfersChanged(bool _state);

    modifier transfersAllowed() {
        require(_allowTransfer);
        _;
    }

    /**
     * @dev ManagedToken constructor
     * @param _owner: Owner
     */
    constructor(string memory _name, string memory _symbol, uint8 _decimals, address _owner) public ERC20Detailed(_name, _symbol, _decimals) {
		_transferOwnership(_owner);
    }

    /**
     * @dev Enable/disable token transfers. Can be called only by owners
     * @param _state: true - allow / false - disable
     */
    function setAllowTransfers(bool _state) external onlyOwner returns (bool) {
        _allowTransfer = _state;
        emit AllowTransfersChanged(_allowTransfer);
        return true;
    }
    
    function allowTransfer() public view returns (bool) {
        return _allowTransfer;
    }

    /**
     * @dev Override transfer function.
     */
    function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
        bool success = super.transfer(_to, _value);
        return success;
    }

    /**
     * @dev Override transferFrom function. Add event listener condition
     */
    function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
        bool success = super.transferFrom(_from, _to, _value);
        return success;
    }
}
