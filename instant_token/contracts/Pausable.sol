pragma solidity ^0.4.17;

import "./Ownable.sol";

/*
 * Pausable
 * Abstract contract with stop ability.
 */

contract Pausable is Ownable {
  bool public stopped;

  modifier stopInEmergency {
    require(!stopped);
    _;
  }
  
  modifier onlyInEmergency {
    require(stopped);
    _;
  }

  function emergencyStop() external onlyOwner {
    stopped = true;
  }

  function release() external onlyOwner onlyInEmergency {
    stopped = false;
  }

}