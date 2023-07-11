// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Bush Contract
 * @dev This contract is a basic implementation of a Merkle Tree.
 */
contract Bush {
    // @notice Array to store the hash values.
    bytes32[] public hashes;

    // @notice A list of predefined transactions. Should be 2 ** n txs in array
    string[4] transactions = [
        "0tx Alice to Bob",
        "1tx Jimm to Sara",
        "2tx Alice to Sara",
        "3tx Bob to Jimm"
    ];

    /**
     * @notice Constructor function that populates the hashes array with hashes of predefined transactions.
     * It also constructs the Merkle Tree by iterating through transactions and hashing them in pairs.
     */
    constructor() {
        // Iterates through the transactions and populates the hashes array.
        for (uint i = 0; i < transactions.length; i++) {
            hashes.push(makeHash(transactions[i]));
        }

        uint count = transactions.length;
        uint offset = 0;

        // Continuously create parent nodes until the root node is created.
        while (count > 0) {
            for (uint i = 0; i < count - 1; i += 2) {
                hashes.push(
                    keccak256(
                        abi.encodePacked(
                            hashes[offset + i],
                            hashes[offset + i + 1]
                        )
                    )
                );
            }
            offset += count;
            count = count / 2;
        }
    }

    /**
     * @notice Verifies if a transaction is included in the Merkle Tree.
     * @param txn The transaction to be verified.
     * @param index The index of the transaction in the list of transactions.
     * @param root The root of the Merkle Tree.
     * @param proof An array of bytes32 that represents the Merkle Proof.
     * @return A boolean value that indicates if the transaction is valid.
     */
    function verify(
        string memory txn,
        uint index,
        bytes32 root,
        bytes32[] memory proof
    ) public pure returns (bool) {
        bytes32 hashh = makeHash(txn);
        for (uint i = 0; i < proof.length; i++) {
            bytes32 element = proof[i];
            if (index % 2 == 0) {
                hashh = keccak256(abi.encodePacked(hashh, element));
            } else {
                hashh = keccak256(abi.encodePacked(element, hashh));
            }
            index = index / 2;
        }

        return hashh == root;
    }

    /**
     * @notice Encodes the input string into bytes using ABI encoding.
     * @param _input The input string to be encoded.
     * @return The ABI encoded bytes.
     */
    function encode(string memory _input) public pure returns (bytes memory) {
        return abi.encodePacked(_input);
    }

    /**
     * @notice Hashes the input string using keccak256.
     * @param _input The input string to be hashed.
     * @return The keccak256 hash of the input string.
     */
    function makeHash(string memory _input) public pure returns (bytes32) {
        return keccak256(encode(_input));
    }
}
