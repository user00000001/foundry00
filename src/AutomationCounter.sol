// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

contract AutomationCounter is AutomationCompatibleInterface {
    uint256 public counter; // Public counter variable

    uint256 public immutable interval; // Use a interval in seconds and a timestamp to slow execution of Upkeep
    uint256 public lastTimeStamp;

    constructor(uint256 updateInterval) {
        interval = updateInterval;
        lastTimeStamp = block.timestamp;
        counter = 0;
    }

    function checkUpkeep(bytes memory /* checkData */ )
        public
        view
        override
        returns (bool, bytes memory /* performData */ )
    {
        bool upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
        // The checkData is defined when the Upkeep was registered.
        return (upkeepNeeded, "");
    }

    function performUpkeep(bytes calldata /* performData */ ) external override {
        (bool upkeepNeeded,) = checkUpkeep(""); // revalidate the `upkeepNeeded` condition.
        require(upkeepNeeded, "Time interval not met");
        lastTimeStamp = block.timestamp;
        counter = counter + 1;
        // The performData is generated by the Automation Node's call to your checkUpkeep function
    }
}