// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract YulIntro {
    function test() external view {
        bytes32 wordFreeMemory;

        assembly {
            let free_memory := mload(0x40) // Loads the value at 0x40
            mstore(free_memory, 32) // Stores the value 32 (0x20) at the free_memory location
            wordFreeMemory := mload(0x40) // Loads the value at 0x40
        }

        console.logBytes32(wordFreeMemory);
        // OUTPUT : 0x0000000000000000000000000000000000000000000000000000000000000080
    }
}
