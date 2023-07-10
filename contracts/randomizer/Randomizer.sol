// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

import "../libs/Errors.sol";
import "../libs/Constants.sol";

contract Randomizer is VRFConsumerBaseV2 {
    uint16 requestConfirmations = 3;
    uint32 numWords = 9;
    uint32 callBackGaslimit = 900000;
    uint64 s_subscriptionId;
    uint256[] public requestIds;
    uint256 public lastRequestId;
    VRFCoordinatorV2Interface immutable COORDINATOR;

    struct RequestStatus {
        bool fulfilled;
        bool exist;
        uint256[] randomWords;
    }

    mapping(uint256 => RequestStatus) public s_requests;

    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    constructor(
        uint64 subscriptionId,
        address coordinatorAddr
    ) VRFConsumerBaseV2(coordinatorAddr) {
        COORDINATOR = VRFCoordinatorV2Interface(coordinatorAddr);
        s_subscriptionId = subscriptionId;
    }

    function requestRandomWords() external returns (uint requestId) {
        requestId = COORDINATOR.requestRandomWords(
            Constants.KEY_HASH,
            s_subscriptionId,
            requestConfirmations,
            callBackGaslimit,
            numWords
        );

        s_requests[requestId] = RequestStatus({
            fulfilled: false,
            exist: true,
            randomWords: new uint[](0)
        });

        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);

        return requestId;
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        require(s_requests[requestId].exist, Errors.REQUEST_NOT_FOUND);
        s_requests[requestId].fulfilled = true;
        s_requests[requestId].randomWords = randomWords;
        emit RequestFulfilled(requestId, randomWords);
    }

    function getRequestStatus(
        uint256 requestId
    ) external view returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[requestId].exist, Errors.REQUEST_NOT_FOUND);
        RequestStatus memory request = s_requests[requestId];
        return (request.fulfilled, request.randomWords);
    }
}
