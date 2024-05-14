// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/PunkgaReward.sol";

contract PunkgaRewardDeployImpl is Script {
    function setUp() public {}

    function run() public {
        // Use address provided in config to broadcast transactions
        vm.startBroadcast();
        // Deploy contract
        PunkgaReward implementation = new PunkgaReward();
        // Stop broadcasting calls from our address
        vm.stopBroadcast();

        console.log(
            "PunkgaReward Implementation Address:",
            address(implementation)
        );
    }
}
