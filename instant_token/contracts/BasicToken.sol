pragma solidity ^0.4.17;

import "./SafeMath.sol";
import "./ERC20Basic.sol";

contract BasicToken is ERC20Basic {
  
  using SafeMath for uint;
  
  mapping(address => uint) balances;
  
  /*
   * Fix for the ERC20 short address attack  
  */
  modifier onlyPayloadWithSize(uint size) {
     require(msg.data.length >= size + 4);
     _;
  }

  function transfer(address _to, uint _value) public onlyPayloadWithSize(2 * 32) {
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
  }

  function balanceOf(address _owner) public constant returns (uint balance) {
    return balances[_owner];
  }
}