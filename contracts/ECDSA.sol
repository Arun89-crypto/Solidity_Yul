// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

library ECDSA {
    bytes32 private constant _MALLEABILITY_THRESHOLD_PLUS_ONE =
        0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a1;

    function recover(
        bytes32 hash,
        bytes calldata signature
    ) internal view returns (address result) {
        assembly {
            if eq(signature.length, 65) {
                // Copy the free memory pointer
                let m := mload(0x40)
                // directly copy r and s from the calldata
                calldatacopy(0x40, signature.offset, 0x40)

                // If 's' in lower half order, such that the signature is not available
                if iszero(gt(mload(0x60), _MALLEABILITY_THRESHOLD_PLUS_ONE)) {
                    mstore(0x00, hash)
                    // compute v and save it in the scratch space
                    mstore(
                        0x20,
                        byte(0, calldataload(add(signature.offset, 0x40)))
                    )

                    pop(
                        staticcall(
                            gas(), // Amount of gas left in transaction
                            0x01, // Address of 'ecrecover'
                            0x00, // Start of input
                            0x80, // Size of input
                            0x40, // Start of output
                            0x20 // Size of output
                        )
                    )
                    // Restore the zero slot
                    mstore(0x60, 0)
                    // 'returndatasize()' will be 0x20 upon sucess, and '0x00' otherwise.
                    result := mload(sub(0x60, returndatasize()))
                }
                // Restore the free memory pointer
                mstore(0x40, m)
            }
        }
    }
}
