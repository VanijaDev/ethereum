/**
  This is a copy of MultiNumberBettingV1 + new functional
 */

pragma solidity ^0.4.4;

contract MultiNumberBettingV2 {

  uint8[] private argArray;
  uint8 private maxValidGuessValue = 10;

  uint8 private loserCount;
  uint8 private winnerCount;

  uint private totalGuessAmount;

  string private lastWinnerName;

  function MultiNumberBettingV2(uint8 _arg0, uint8 _arg1, uint8 _arg2) public payable {
    argArray = [_arg0, _arg1, _arg2];
  }

  function() public payable {  }

  function guess(uint8 _guess, string _name) public guessIsValidValue(_guess) returns(bool) {
    //  increase totalGuessAmount
    guessOccured();

    //  check is guessed
    uint8 length = uint8(argArray.length);
    for (uint8 i = 0; i < length; i ++) {
      if (_guess == argArray[i]) {
        guessSucceded(_name);

        return true; 
      }
    }

    guessFailed();
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

  function getLastWinnerName() public returns(string) {
    return bytes(lastWinnerName).length > 0 ? lastWinnerName : "***";
  }

//  private helpers
  function guessOccured() private {
    totalGuessAmount += 1;
  }

  function guessSucceded(string _name) private {
      winnerCount += 1;

      require(winnerCount > 0);
      
      lastWinnerName = _name;
  }

  function guessFailed() private {
    loserCount += 1;
  }

  //  modifiers
  modifier guessIsValidValue(uint _guess) {
    require(_guess < maxValidGuessValue);
    _;
  }

}
