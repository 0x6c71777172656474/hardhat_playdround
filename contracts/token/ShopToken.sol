// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;
import "./ERC20.sol";

contract ShopToken is ERC20 {
    constructor(address shop) ERC20("Shop Token", "SHT", 1000, shop) {}
}
