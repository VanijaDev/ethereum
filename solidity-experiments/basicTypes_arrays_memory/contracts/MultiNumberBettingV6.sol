/**
  This is a copy of MultiNumberBettingV5 + new functional
 */

pragma solidity ^0.4.4;

import "./MultiNumberBettingAbstractV2.sol";

contract MultiNumberBettingV6 is MultiNumberBettingAbstractV2 {
  
  struct Winner {
    address addr;
    string name;
    uint8 guess;
    uint guessedAt;
    uint etherProvided;
    uint winCount;
    uint pendingPrizePayout;  //  used if not enough ether in contract at the moment of winning.
  }

  uint8 constant private MAX_VALID_GUESS_VALUE = 10;

  uint8[] private argArray;
  
  uint16 public totalGuessCount;
  uint8 public loserCount;

  address public lastWinnerAddress;
  mapping(address => Winner) private winners;
  address[] private pendingPrizePayoutAddresses;

  function MultiNumberBettingV6(uint8 _arg0, uint8 _arg1, uint8 _arg2) public payable {
    owner = msg.sender;
    argArray = [_arg0, _arg1, _arg2];
  }

  function() public payable {  }

  function test(uint8 _g, string _n) public payable returns(uint) {
    require(msg.value >= (2 * MAX_BET));
    return 777;
  }

  // MultiNumberBettingAbstractV1 methods
  function guess(uint8 _guess, string _name) public payable enoughFundsForGuess(msg.value) returns(bool) {
    sendPendingPrizePayouts();

    require(_guess < MAX_VALID_GUESS_VALUE);
    require((msg.value >= MIN_BET) && (msg.value <= MAX_BET));

    totalGuessCount += 1;

    //  check is guessed
    uint8 length = uint8(argArray.length);
    for (uint8 i = 0; i < length; i ++) {
      if (_guess == argArray[i]) {
        guessSuccessfulWith(msg.sender, _name, _guess, now, msg.value);

        return true; 
      }
    }

    guessFailed();
    return false; 
  }

  function totalGuesses() public constant returns(uint guesses) {
    guesses = totalGuessCount;
  }

  function getLastWinnerInfo() public constant returns(address winnerAddr, string winnerName, uint winnerGuessedAt, uint etherProvided) {
    Winner memory lastWinner = winners[lastWinnerAddress];

    winnerAddr = lastWinner.addr;
    winnerName = lastWinner.name;
    winnerGuessedAt = lastWinner.guessedAt;
    etherProvided = lastWinner.etherProvided;
  }

  //winner address, winner name, guessedNumber, timeGuessed
  function checkWinning(address _addr) public constant returns (address winnerAddr, string winnerName, uint8 winnerGuess, uint winnerGuessedAt, uint etherProvided) {
    Winner memory winner = winners[_addr];
    
    if (winner.addr != 0x0) {
      winnerAddr = winner.addr;
      winnerName = winner.name;
      winnerGuess = winner.guess;
      winnerGuessedAt = winner.guessedAt;
      etherProvided = winner.etherProvided;

      return;
    }

    winnerAddr = 0x0;
    winnerName = "";
    winnerGuess = 0;
    winnerGuessedAt = 0;
    etherProvided = 0;
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

  function ownerWithdraw(uint amount) public constant onlyOwner() {
    require((this.balance - amount) >= MAX_BET * 2);

    msg.sender.transfer(this.balance);
  }

//  private helpers
  function guessSuccessfulWith(address _addr, string _name, uint8 _guess, uint _guessedAt, uint _etherProvided) private {
    Winner memory winner = winners[_addr];
    if (winners[_addr].addr == 0x0) {
      winner = Winner({addr: _addr, name: _name, guess: _guess, guessedAt: _guessedAt, etherProvided: _etherProvided, winCount: 1, pendingPrizePayout: 0});
    } else {
      winner.name = _name;
      winner.guess = _guess;
      winner.guessedAt = _guessedAt;
      winner.etherProvided = _etherProvided;
      winner.winCount += 1;
    }
    
    lastWinnerAddress = winner.addr;
    winners[_addr] = winner;
    sendEtherPrize(winner);
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

  function sendEtherPrize(Winner _winner) private {
    uint prizeEther = _winner.etherProvided * 2;
    
    if (prizeEther <= this.balance) {
      _winner.addr.transfer(prizeEther);
    } else {
      _winner.pendingPrizePayout += prizeEther;
      pendingPrizePayoutAddresses.push(_winner.addr);
    }
  }

  function sendPendingPrizePayouts() private {
    if (this.balance == 0) {
      return;
    }

    for (uint i = pendingPrizePayoutAddresses.length; i >= 0; i --) {
      Winner memory winner = winners[pendingPrizePayoutAddresses[i]];
      uint prizeEth = winner.pendingPrizePayout;
      
      if (prizeEth >= this.balance) {
        winner.addr.transfer(prizeEth);

        winner.pendingPrizePayout = 0;
        delete pendingPrizePayoutAddresses[i];
      }
    }
  }

}
