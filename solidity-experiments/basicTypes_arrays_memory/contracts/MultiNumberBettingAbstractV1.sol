pragma solidity ^0.4.4;

contract MultiNumberBettingAbstractV1 {
  uint public constant MAX_BET = 0.0005 ether;
  uint public constant MIN_BET = 0.000001 ether;

  function guess(uint8 _guess, string _name) public payable returns(bool);
  function totalGuesses() public constant returns(uint guesses);
  function getLastWinnerInfo() public constant returns(address winnerAddr, string winnerName, uint winnerGuessedAt, uint etherProvided);
  function checkWinning(address _addr) public constant returns (address winnerAddr, string winnerName, uint8 winnerGuess, uint winnerGuessedAt, uint etherProvided);
  function daysSinceLastWinning() public constant returns(uint);
  function hoursSinceLastWinning() public constant returns(uint);
  function minutesSinceLastWinning() public constant returns(uint);
}
