pragma solidity ^0.4.4;

contract Calculator {

  uint result;

  function Calculator(uint initial) {
    result = initial;
  }

  function getResult() constant returns(uint num) {
    return result;
  }

  function addToNumber(uint num) {
    result += num;
  }

  function substractFromNumber(uint num) {
    result -= num;
  }

  function multiplyWithNumber(uint num) {
    result *= num;
  }

  function divideByNumber(uint num) {
    result /= num;
  }

  function anyString() constant returns(string) {
    return "Here is string";
  }

  function double() {
    result *= 2;
  }

  function half() {
    result /= 2;
  }
}
