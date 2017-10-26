/**
  This is a copy of MultiNumberBettingV2 + new functional
 */

pragma solidity ^0.4.4;

contract MultiNumberBettingV3 {

  uint8[] private argArray;
  uint8 private maxValidGuessValue = 10;

  string private lastWinnerName;
  
  uint8 public loserCount;
  uint8 public winnerCount;
  uint public lastWinnerAt; //  timestamp

  address public lastWinnerAddress;

  function MultiNumberBettingV3(uint8 _arg0, uint8 _arg1, uint8 _arg2) public payable {
    argArray = [_arg0, _arg1, _arg2];
  }

  function() public payable {  }

  function guess(uint8 _guess, string _name) public guessIsValidValue(_guess) returns(bool) {
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
    guesses = winnerCount + loserCount;
  }

  function getLastWinnerName() public returns(string) {
    return bytes(lastWinnerName).length > 0 ? lastWinnerName : "***";
  }

  //  winning time
  function daysSinceLastWinning() public constant returns(uint) {
    return timeSinceLastWinner() * 1 days;
  }
  
  function hoursSinceLastWinning() public constant returns(uint) {
    return timeSinceLastWinner() * 1 hours;
  }

  function minutesSinceLastWinning() public constant returns(uint) {
    return timeSinceLastWinner() * 1 minutes;
  }


//  private helpers
  function guessSucceded(string _name) private {
      winnerCount += 1;

      require(winnerCount > 0);
      
      lastWinnerAddress = msg.sender;
      lastWinnerName = _name;
      lastWinnerAt = now;
  }

  function guessFailed() private {
    loserCount += 1;

    require(loserCount > 0);
  }
  
  function timeSinceLastWinner() private constant returns(uint) {
    uint timeSince = now - lastWinnerAt * 1 seconds;

    timeSince < now ? lastWinnerAt : 0;
  }

  //  modifiers
  modifier guessIsValidValue(uint _guess) {
    require(_guess < maxValidGuessValue);
    _;
  }

}
