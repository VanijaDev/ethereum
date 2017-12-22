pragma solidity ^0.4.15;
contract NumberContract {
    address creator;
    uint256 myNumber;
    uint totalSupply;

    mapping(address => uint) totalAmount;

    function NumberContract() public {
        creator = msg.sender;
        myNumber = 3;
        totalSupply = 21000000;
    }

    function getCreator() public constant returns(address) {
        return creator;
    }

    function getMyNumber() public constant returns(uint256) {
        return myNumber;
    }

    function setMyNumber(uint256 myNewNumber) public {
        myNumber = myNewNumber;
    }

    function kill() public {
        if(msg.sender == creator) {
            selfdestruct(creator);
        }
    }
}