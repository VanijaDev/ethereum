pragma solidity ^0.4.0;

// Proof of Existence contract, version 2
contract ProofOfExistence2 {
    mapping(bytes32 => bool) private proofs;

    // store a proof of existence in the contract state
        // *transactional function*
    function storeProof(bytes32 proof) private {
        proofs[proof] = true;
    }

    // calculate and store the proof for a document
        // *transactional function*
    function notarize(string document) public {
        bytes32 proof = proofFor(document);
        storeProof(proof);
    }

    // helper function to get a document's sha256
        // *read-only function*
    function proofFor(string document) private constant returns (bytes32) {
        return sha256(document);
    }

    // check if a document has been notarized
        // *read-only function*
    function checkDocument(string document) public constant returns(bool) {
        bytes32 proof = sha256(document);
        return hasProof(proof);
    }

    // returns true if proof is stored
        //   *read-only function*
    function hasProof(bytes32 proof) private constant returns(bool) {
        return proofs[proof];
    }

}