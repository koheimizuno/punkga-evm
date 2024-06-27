// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/PunkgaReward_v2.sol";

contract PunkgaRewardV2DeployImpl is Script {
    function setUp() public {}

    function run() public {
        // Use address provided in config to broadcast transactions
        vm.startBroadcast();
        // Deploy contract
        PunkgaRewardV2 implementation = new PunkgaRewardV2();
        // Stop broadcasting calls from our address
        vm.stopBroadcast();

        console.log("PunkgaRewardV2 Implementation Address:", address(implementation));
    }
}
