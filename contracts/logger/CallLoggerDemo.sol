// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interface/ILogger.sol";
import {Errors} from "../libs/Errors.sol";

contract CallLoggerDemo {
    ILogger logger;

    constructor(address _logger) {
        logger = ILogger(_logger);
    }

    function payment(address _from, uint _index) public view returns (uint) {
        require(_from != address(0), Errors.ZERO_ADDRESS);
        return logger.getEntry(_from, _index);
    }

    receive() external payable {
        logger.log(msg.sender, msg.value);
    }
}
