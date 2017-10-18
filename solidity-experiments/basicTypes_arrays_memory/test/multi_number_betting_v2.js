/**
  This is a copy of multi_number_betting_v1 + new functional
 */

var MultiNumberBettingV2 = artifacts.require("./MultiNumberBettingV2.sol");

contract('MultiNumberBettingV2', function(accounts) {
  
  var bettingContract;

  describe("Initial tests", function() {
    beforeEach(function() {
      console.log("New test.");
    });

    it("MultiNumberBettingV2 initialize.", function() {
      return MultiNumberBettingV2.deployed().then(function(instance) {
        assert.notEqual(instance, null, "Contract must be initialized.");

        bettingContract = instance;

        return bettingContract.totalGuesses.call();
      }).then(function(totalGuesses) {
        assert.equal(totalGuesses.valueOf(), 0, "Initial total guesses should be 0.");

        return bettingContract.getLastWinnerName.call();
      }).then(function(name) {
        assert.equal(name, "***", "No winner name yet, must be '***' string.");

      });
    });

    it("Test guess() function return values.", function() {
      return bettingContract.guess.call(1,"Ivan").then(function(success) {
        assert.isTrue(success, "1 is valid guess, must be true.");

        return bettingContract.guess.call(4, "Kolia");
      }).then(function(success) {
        assert.isFalse(success, "4 is invalid guess, must be false.");

        return bettingContract.guess.call(3, "Ivan");
      }).then(function(success) {
        assert.isTrue(success, "3 is invalid guess, must be true.");
      });
    });

    it("Test total count increment", function() {
      bettingContract.guess(1, "Ivan");
      bettingContract.guess(3, "Oleg");
      bettingContract.guess(4, "Igor"); // lose

      return bettingContract.totalGuesses.call().then(function(totalGuesses) {
        assert.equal(totalGuesses.valueOf(), 3, "totalGuesses must be 3.");
        
      }).then(function() {

        return bettingContract.loseGuessesCount.call();
      }).then(function(loses) {
        assert.equal(loses.toNumber(), 1, "loses must be 1.");

        return bettingContract.winnerGuessesCount.call();
      }).then(function(wins) {
        assert.equal(wins.valueOf(), 2, "wins must be 2.");
      });
    });

    it("Test last winner name", function() {
      bettingContract.guess(1, "Hero");
      return bettingContract.getLastWinnerName.call().then(function(name) {
        assert.equal(name, "Hero", "must be Hero.");

        bettingContract.guess(6, "Loser");
        return bettingContract.getLastWinnerName.call();
      }).then(function(name) {
        assert.equal(name, "Hero", "must be Hero here also.");
      });
    });
  });
});