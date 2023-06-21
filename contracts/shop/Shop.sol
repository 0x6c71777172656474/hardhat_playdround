// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "../interface/IERC20.sol";
import {Errors} from "../libs/Errors.sol";
import {ShopToken} from "../token/ShopToken.sol";

contract Shop {
    IERC20 public token;
    address payable owner;
    event Bought(uint _amount, address indexed _buyer);
    event Sold(uint _amount, address indexed _seller);

    constructor() {
        token = new ShopToken(address(this));
        owner = payable(msg.sender);
    }

    receive() external payable {
        uint tokensToBuy = msg.value;
        require(tokensToBuy > 0, Errors.NOT_ENOUGH_FUNDS);
        require( tokenBalance() >= tokensToBuy, Errors.NOT_ENOUGH_SHOP_TOKENS);
        token.transfer(msg.sender, tokensToBuy);
        emit Bought(tokensToBuy, msg.sender);
    }

    function sell(uint _amount) public {
        require(_amount > 0 && token.balanceOf(msg.sender) >= _amount, Errors.INCORRECT_AMOUNT);
        uint allowance = token.allowance(msg.sender, address(this));
        require(allowance >= _amount, Errors.OVER_ALLOWANCE);
        token.transferFrom(msg.sender, address(this), _amount);
        require(tokenBalance() >= _amount, Errors.NOT_ENOUGH_FUNDS);
        payable(msg.sender).transfer(_amount);
        emit Sold(_amount, msg.sender);
    }

    function tokenBalance() public view returns(uint) {
        return token.balanceOf(address(this));
    }

    function withdraw() external onlyOwner {
        require(address(this).balance > 0, Errors.NOT_ENOUGH_FUNDS);
        payable(msg.sender).transfer(address(this).balance);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, Errors.NOT_OWNER);
        _;
    }
}
