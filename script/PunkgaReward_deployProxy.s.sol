// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../src/PunkgaReward.sol";

contract PunkgaRewardDeployProxy is Script {
    function setUp() public {}

    function run() public {
        address _implementation = 0x2CF8129354C0e07198ae941166E32EC4DE58245E; // Replace with your token address
        vm.startBroadcast();

        // Encode the initializer function call
        bytes memory data = abi.encodeWithSelector(
            PunkgaReward(_implementation).initialize.selector,
            msg.sender // Initial owner/admin of the contract
        );

        // Deploy the proxy contract with the implementation address and initializer
        ERC1967Proxy proxy = new ERC1967Proxy(_implementation, data);

        vm.stopBroadcast();
        // Log the proxy address
        console.log("UUPS Proxy Address:", address(proxy));
    }
}
