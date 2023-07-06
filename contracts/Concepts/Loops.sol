// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SumDemo0 {
    function sum(uint256[] memory a) public pure returns (uint256 result) {
        assembly {
            let n := mload(a) // This will load the length of the array in variable 'n' as in memory array length is stored at the memory location of array.

            // FOR LOOP
            for {
                let i := 0
            } lt(i, n) {
                i := add(i, 1)
            } {
                result := add(result, mload(add(add(a, 0x20), mul(i, 0x20))))
            }

            /*
            How this works ? :

            * add(a,0x20)
            -> This will return the index of the first element in the memory

            * mul(i,0x20)
            -> This will return the relative index of the element as per the first element

            * add(add(a,0x20), mul(i,0x20))
            -> This will ad both the results and then gets us the memory location of the next element

            * mload(add(add(a, 0x20), mul(i, 0x20)))
            -> This will load the element from memory

            * add(result, mload(add(add(a, 0x20), mul(i, 0x20))))
            -> This will add the loaded element into the result variable

            ! The above steps repeat until the 'i' is less than the 'n'.

             */
        }
    }
}

// Improved Version
contract SumDemo1 {
    function sum(uint256[] memory a) public pure returns (uint256 result) {
        assembly {
            let n := mload(a)
            for {
                let i := 0
            } iszero(eq(i, n)) {
                i := add(i, 1)
            } {
                result := add(result, mload(add(add(a, 0x20), mul(i, 0x20))))
            }

            /*
            How this works ? :

            -> Here the most of the code is same but instead of using the less than to check when to terminate the loop we are using :

            * iszero(eq(i,n))

            ! -> eq(i,n) :
            
            Returns 0 if i == n else returns 1

            ! iszero(eq(i,n)) :

            This will return true(0) or false(1) depending upon the result of 'eq' operation

            ? >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            ? FASTER APPROACH THAN "SumDemo0"
            ? >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

             */
        }
    }
}

// Another improved implementation
contract SumDemo2 {
    function sum(uint256[] memory a) public pure returns (uint256 result) {
        assembly {
            let n := mload(a)
            let end := add(add(a, 0x20), mul(0x20, n))

            for {
                let i := 0
            } iszero(eq(i, end)) {
                i := add(i, 1)
            } {
                result := add(result, mload(add(add(a, 0x20), mul(i, 0x20))))
            }

            /* 

            ? >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            ? FASTER APPROACH THAN "SumDemo0" & "SumDemo1"
            ? >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

             */
        }
    }
}

// Another improved implementation
contract SumDemo3 {
    function sum(uint256[] memory a) public pure returns (uint256 result) {
        assembly {
            let n := mload(a)

            if n {
                let end := add(add(a, 0x20), mul(0x20, n))
                // ! ALTERNATE (LESS_GAS)
                // let end := add(add(a, 0x20), shl(5, n))
                let i := add(a, 0x20)
                for {

                } 1 {

                } {
                    result := add(result, mload(i))
                    i := add(i, 0x20)
                    if eq(i, end) {
                        break
                    }
                }
            }

            /* 

            Here we are using an infinite loop with some modifications in the code.

            ? >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            ? FASTER APPROACH THAN "SumDemo0" & "SumDemo1"
            ? >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

             */
        }
    }
}

// If we use calldata instead of memory
contract SumDemo4 {
    function sum(uint256[] calldata a) public pure returns (uint256 result) {
        assembly {
            let n := calldataload(a.length)

            if n {
                let end := add(a.offset, mul(0x20, n))
                // ! ALTERNATE (LESS_GAS)
                // let end := add(add(a, 0x20), shl(5, n))
                let i := a.offset
                for {

                } 1 {

                } {
                    result := add(result, calldataload(i))
                    i := add(i, 0x20)
                    if eq(i, end) {
                        break
                    }
                }
            }
        }
    }
}
