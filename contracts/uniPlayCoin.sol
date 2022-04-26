//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
contract uniPlayCoin is ERC20Upgradeable, OwnableUpgradeable {

    uint public taxPercent;
    address public _treasury;
    uint public maxSupply;
    uint public maxTransferLimit;

    function initialize (
    string memory name,
    string memory symbol,
    address treasury,
    uint _maxSupply,
    uint _taxPercent)
    public initializer {
        __ERC20_init(name, symbol);
        __Ownable_init();
        taxPercent = _taxPercent;
        _treasury = treasury;
        maxSupply = _maxSupply;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        require (amount<= maxTransferLimit,'Limit Exceed To Transfer');
        uint exactTaxAmount = (amount * taxPercent)/1000;
        uint amountToTransfer = amount - exactTaxAmount;
        super._transfer(from,_treasury,exactTaxAmount);
        super._transfer(from,to,amountToTransfer);
    }

    function mintToken (uint amount, address receiver) external onlyOwner {
        require (totalSupply()+amount <= maxSupply,'Supply Limit');
        maxSupply+=amount;
        _mint(receiver, amount);
    }

    function burnToken (uint amount) external {
        maxSupply-=amount;
        _burn(msg.sender, amount);
    }

    function setTreasury (address treasury) external onlyOwner {
        _treasury = treasury;
    }

    function setMaxTokenSupply (uint amount) external onlyOwner {
        maxSupply = amount;
    }

    function setTaxPercent(uint percent) external onlyOwner {
        taxPercent = percent;
    }

    function setMaxTransferLimit (uint amount) external onlyOwner {
        maxTransferLimit = amount;
    }
}

