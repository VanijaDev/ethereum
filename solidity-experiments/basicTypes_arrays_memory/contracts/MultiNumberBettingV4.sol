/**
  This is a copy of MultiNumberBettingV3 + new functional
 */

pragma solidity ^0.4.4;

contract MultiNumberBettingV4 {

  struct Winner {
    address addr;
    string name;
    uint8 guess;
    uint guessedAt;
  }

  uint8[] private argArray;
  uint8 private maxValidGuessValue = 10;
  
  uint16 public totalGuessCount;
  uint8 public loserCount;

  address public lastWinnerAddress;
  mapping(address => Winner) winners;

  function MultiNumberBettingV4(uint8 _arg0, uint8 _arg1, uint8 _arg2) public payable {
    argArray = [_arg0, _arg1, _arg2];
  }

  function() public payable {  }

  function guess(uint8 _guess, string _name) public guessIsValidValue(_guess) returns(bool) {
    totalGuessCount += 1;

    //  check is guessed
    uint8 length = uint8(argArray.length);
    for (uint8 i = 0; i < length; i ++) {
      if (_guess == argArray[i]) {

        Winner memory winner = winnerObjectFromData(msg.sender, _name, _guess, now);
        appendNewWinner(winner);

        return true; 
      }
    }

    guessFailed();
    return false; 
  }

  function totalGuesses() public constant returns(uint guesses) {
    guesses = totalGuessCount;
  }

  function getLastWinnerInfo() public constant returns(address winnerAddr, string winnerName, uint winnerGuessedAt) {
    Winner memory lastWinner = winners[lastWinnerAddress];

    winnerAddr = lastWinner.addr;
    winnerName = lastWinner.name;
    winnerGuessedAt = lastWinner.guessedAt;
  }
//winner address, winner name, guessedNumber, timeGuessed
  function checkWinning(address _addr) public constant returns (address winnerAddr, string winnerName, uint8 winnerGuess, uint winnerGuessedAt) {
    Winner memory winner = winners[_addr];
    
    if (winner.addr != 0x0) {
      winnerAddr = winner.addr;
      winnerName = winner.name;
      winnerGuess = winner.guess;
      winnerGuessedAt = winner.guessedAt;

      return;
    }

    winnerAddr = 0x0;
    winnerName = "";
    winnerGuess = 0;
    winnerGuessedAt = 0;
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
  function winnerObjectFromData(address _addr, string _name, uint8 _guess, uint _guessedAt) private returns(Winner) {
      return Winner(_addr, _name, _guess, _guessedAt);
  }

  function appendNewWinner(Winner _winner) private {
    winners[_winner.addr] = _winner;
    lastWinnerAddress = _winner.addr;
  }

  function guessFailed() private {
    loserCount += 1;

    require(loserCount > 0);
  }
  
  function timeSinceLastWinner() private constant returns(uint) {
    Winner storage lastWinner = winners[lastWinnerAddress];

    if (lastWinner.addr == 0x0) {
      return 0;
    }

    uint timeSince = now - (lastWinner.guessedAt * 1 seconds);

    return timeSince;
  }

  //  modifiers
  modifier guessIsValidValue(uint _guess) {
    require(_guess < maxValidGuessValue);
    _;
  }

}
