// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract operatorShift {
    uint256 public s;

    // Generating an identifier that is unique
    // * (block.timestamp << 160) -> left shift the block timestamp by 160 positions
    // -> block.timestamp * (2**160)
    // * uint256(uint160(msg.sender))
    // * OR operation on both
    constructor() {
        s = (block.timestamp << 160) | uint256(uint160(msg.sender));
    }

    function getS() public view {
        console.log(s);
        // console.log(block.timestamp << 160);
        // console.log(uint160(msg.sender));
        // console.log(uint256(uint160(msg.sender)));
        address storedCaller = address(uint160(s)); // This will get the address from the stored unique variable
        console.log(storedCaller);
    }

    function callerIsStoredPlainSolidity() public view returns (bool result) {
        address storedCaller = address(uint160(s));
        result = storedCaller == msg.sender;
    }

    function callerIsStoredAssemblyWrong() public view returns (bool result) {
        address storedCaller = address(uint160(s));
        assembly {
            result := eq(storedCaller, caller())
        }
        console.log(storedCaller);
        console.log(result);
    }

    // Correct Syntax
    function callerIsStoredAssemblyCorrect() public view returns (bool result) {
        address storedCaller = address(uint160(s));
        assembly {
            storedCaller := shr(96, shl(96, storedCaller))
            result := eq(storedCaller, caller())
        }
        console.log(storedCaller);
        console.log(result);
    }

    // Another correct syntax
    // using : 0xffffffffffffffffffffffffffffffffffffffff
    function callerIsStoredAssemblyCorrectAnother()
        public
        view
        returns (bool result)
    {
        address storedCaller = address(uint160(s));
        assembly {
            storedCaller := and(
                0xffffffffffffffffffffffffffffffffffffffff,
                storedCaller
            )
            result := eq(
                storedCaller,
                and(0xffffffffffffffffffffffffffffffffffffffff, caller())
            )
        }
        console.log(storedCaller);
        console.log(result);
    }
}
