pragma solidity ^0.4.4;

contract MultiNumberBettingV1 {

  uint8[] private argArray;
  uint8 private maxValidGuessValue = 10;

  uint8 private loserCount;
  uint8 private winnerCount;

  uint private totalGuessAmount;

  function MultiNumberBettingV1(uint8 _arg0, uint8 _arg1, uint8 _arg2) public payable {
    argArray = [_arg0, _arg1, _arg2];
  }

  function() public payable {  }

  function guess(uint8 _guess) public guessIsValidValue(_guess) returns(bool) {
    //  increase totalGuessAmount
    guessOccured();

    //  check is guessed
    uint8 length = uint8(argArray.length);
    for (uint8 i = 0; i < length; i ++) {
      if (_guess == argArray[i]) {
        winnerCount += 1;
        require(winnerCount > 0);
        return true; 
      }
    }
    loserCount += 1;
    return false; 
  }

  function totalGuesses() public constant returns(uint guesses) {
    guesses = totalGuessAmount;
  }

  function loseGuessesCount() public constant returns(uint) {
    return loserCount;
  }

  function winnerGuessesCount() public constant returns(uint) {
    return winnerCount;
  }

//  private helpers
  function guessOccured() private {
    totalGuessAmount += 1;
  }

  //  modifiers
  modifier guessIsValidValue(uint _guess) {
    require(_guess < maxValidGuessValue);
    _;
  }

}