// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract operatorShift {
    function leftShiftBy2(uint256 a) public view returns (uint256 result) {
        assembly {
            let n := mload(a)

            result := shl(2, a)
        }
        /**
        shl(shift, val)
        suppose a = 3
        result = a << 2 = 3 << 2 = 3 * (2 ** 2) = 12

        8 4 2 1
        -------
        0 0 1 1
        -> After left shift
        8 4 2 1
        -------
        1 1 0 0
         */

        console.log(result);
    }

    function rightShiftBy2(uint256 a) public view returns (uint256 result) {
        assembly {
            let n := mload(a)

            result := shr(2, a)
        }
        /**
        shr(shift, val)
        suppose a = 4
        result = a >> 2 = 4 >> 2 = 4 / (2 ** 2) = 1

        8 4 2 1
        -------
        0 1 0 0
        -> After right shift
        8 4 2 1
        -------
        0 0 0 1
         */

        console.log(result);
    }
}
