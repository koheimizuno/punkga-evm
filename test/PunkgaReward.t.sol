// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PunkgaReward.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";

contract PunkgaRewardTest is Test {
    PunkgaReward reward;
    ERC1967Proxy proxy;
    address owner;
    address newOwner;

    // Set up the test environment before running tests
    function setUp() public {
        // Deploy the token implementation
        PunkgaReward implementation = new PunkgaReward();
        // Define the owner address
        owner = vm.addr(1);
        // Deploy the proxy and initialize the contract through the proxy
        proxy = new ERC1967Proxy(
            address(implementation),
            abi.encodeCall(implementation.initialize, owner)
        );
        // Attach the PunkgaReward interface to the deployed proxy
        reward = PunkgaReward(address(proxy));
        // Define a new owner address for upgrade tests
        newOwner = address(1);
        // Emit the owner address for debugging purposes
        emit log_address(owner);
    }

    // Test the basic ERC20 functionality of the MyToken contract
    function testUpdateUserInfo() public {
        // Impersonate the owner to call mint function
        vm.prank(owner);

        reward.updateUserInfo(address(2), 100, 100);
    }

    // // Test the upgradeability of the MyToken contract
    // function testUpgradeability() public {
    //     // Upgrade the proxy to a new version; PunkgaRewardV2
    //     Upgrades.upgradeProxy(
    //         address(proxy),
    //         "PunkgaRewardV2.sol:PunkgaRewardV2",
    //         "",
    //         owner
    //     );
    // }
}
