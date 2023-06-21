// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interface/IERC20.sol";
import {Errors} from "../libs/Errors.sol";

contract ERC20 is IERC20 {
    uint totalCurrentAmount;
    address owner;
    string _name;
    string _symbol;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;

    constructor(
        string memory name_,
        string memory symbol_,
        uint initialSupply,
        address shop
    ) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        mint(initialSupply, shop);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external pure returns (uint) {
        return 18;
    }

    function totalSupply() external view returns (uint) {
        return totalCurrentAmount;
    }

    function balanceOf(address _account) public view returns (uint) {
        return balances[_account];
    }

    function _transfer(address to, uint amount) internal {
        _beforeTokenAction(msg.sender, to, amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    function transfer(address to, uint amount) external {
        _transfer(to, amount);
    }

    function allowance(
        address _owner,
        address spender
    ) public view returns (uint) {
        return allowances[_owner][spender];
    }

    function _approve(
        address _sender,
        address _spender,
        uint _amount
    ) internal virtual {
        _beforeTokenAction(_sender, _spender, _amount);
        allowances[_sender][_spender] = _amount;
        emit Approve(_sender, _spender, _amount);
    }

    function approve(address spender, uint amount) external {
        _approve(msg.sender, spender, amount);
    }

    function transferFrom(
        address sender,
        address recepient,
        uint amount
    ) public {
        _beforeTokenAction(sender, recepient, amount);
        require(allowances[sender][recepient] >= amount, Errors.OVER_ALLOWANCE);
        allowances[sender][recepient] -= amount;
        balances[sender] -= amount;
        balances[recepient] += amount;
        emit Transfer(sender, recepient, amount);
    }

    function _mint(uint _amount, address _to) internal onlyOwner {
        _beforeTokenAction(address(0), _to, _amount);
        balances[_to] += _amount;
        totalCurrentAmount += _amount;
        emit Transfer(address(0), _to, _amount);
    }

    function mint(uint amount, address to) public onlyOwner {
        _mint(amount, to);
    }

    function _burn(
        uint _amount,
        address _from,
        address _who
    ) internal onlyOwner enoughTokens(_from, _amount) {
        balances[_from] -= _amount;
        totalCurrentAmount -= _amount;
        emit Burn(_from, _who, _amount);
    }

    function burn(uint amount, address from) external {
        _burn(amount, from, msg.sender);
    }

    function _beforeTokenAction(
        address from,
        address to,
        uint amount
    ) internal virtual enoughTokens(from, amount) {
        require(to != address(0), Errors.ZERO_ADDRESS);
        require(amount > 0, Errors.INCORRECT_AMOUNT);
    }

    modifier enoughTokens(address _from, uint _amount) {
        if (_from != address(0))
            require(balanceOf(_from) >= _amount, Errors.NOT_ENOUGH_SHOP_TOKENS);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, Errors.NOT_OWNER);
        _;
    }
}
