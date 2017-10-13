pragma solidity ^0.4.0;

//  proof of existence contract version 1

contract ProofOfExistence1 {
  bytes32 public proof;

  function notarize(string document) public {
    proof = calculateProof(document);
  }

  function calculateProof(string document) public constant returns(bytes32) {
    return sha256(document);
  }
}