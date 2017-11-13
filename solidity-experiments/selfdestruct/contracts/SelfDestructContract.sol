pragma solidity ^0.4.15;

contract SelfDestructContract {

    address private owner;
    string public someString;

    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }

  function SelfDestructContract() public {
    owner = msg.sender;
  }

  function () public {  }

  function updateSomeString(string _str) public {
    someString = _str;
  }

  function killTheContract() onlyOwner() public {
    selfdestruct(owner);
  }

}
