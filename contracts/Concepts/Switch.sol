// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Switchcases {
    function lookup(uint256 i) public pure returns (uint256 result) {
        assembly {
            switch i
            case 0 {
                result := 10001
            }
            case 1 {
                result := 10002
            }
            case 3 {
                result := 10003
            }
            default {
                result := 0
            }
        }
    }

    function lookup1(uint256 i) public pure returns (uint256 result) {
        assembly {
            for {

            } 1 {

            } {
                if eq(i, 0) {
                    result := 10001
                    break
                }
                if eq(i, 1) {
                    result := 10002
                    break
                }
                result := 0
                break
            }
        }
    }

    function lookup2(uint256 i) public pure returns (uint256 result) {
        assembly {
            for {

            } 1 {

            } {
                if iszero(i) {
                    result := 10001
                    break
                }
                if iszero(gt(i, 1)) {
                    result := 10002
                    break
                }
                result := 0
                break
            }
        }
    }
}
