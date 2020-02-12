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

    bool public allowTransfers = false;

    event AllowTransfersChanged(bool _newState);
    event Destroy(address indexed _from, uint256 _value);

    modifier transfersAllowed() {
        require(allowTransfers);
        _;
    }

    /**
     * @dev ManagedToken constructor
     * @param _owner Owner
     */
    constructor(string memory _name, string memory _symbol, uint8 _decimals, address _owner) public ERC20Detailed(_name, _symbol, _decimals) {
		_transferOwnership(_owner);
    }

    /**
     * @dev Enable/disable token transfers. Can be called only by owners
     * @param _allowTransfers True - allow False - disable
     */
    function setAllowTransfers(bool _allowTransfers) external onlyOwner {
        allowTransfers = _allowTransfers;
        emit AllowTransfersChanged(_allowTransfers);
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

    /**
     * @dev Destroy tokens on specified address (Called by owner or token holder)
     * @dev Fund contract address must be in the list of owners to burn token during refund
     * @param _from Wallet address
     * @param _value Amount of tokens to destroy
     */
    function destroy(address _from, uint256 _value) external {
    }
}
