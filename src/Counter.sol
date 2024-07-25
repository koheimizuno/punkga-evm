// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public num;

    function setNumber(uint256 newNum) public {
        num = newNum;
    }

    function increment() public {
        num++;
    }
}
