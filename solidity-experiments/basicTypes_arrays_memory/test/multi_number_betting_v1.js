var MultiNumberBettingV1 = artifacts.require("./MultiNumberBettingV1.sol");

contract('MultiNumberBettingV1', function(accounts) {
  
  var bettingContract;

  describe("Initial tests", function() {
    beforeEach(function() {
      console.log("New test.");
    });

    it("MultiNumberBettingV1 initialize.", function() {
      return MultiNumberBettingV1.deployed().then(function(instance) {
        assert.notEqual(instance, null, "Contract must be initialized.");

        bettingContract = instance;

        return bettingContract.totalGuesses.call();
      }).then(function(totalGuesses) {
        assert.equal(totalGuesses.valueOf(), 0, "Initial total guesses should be 0.");
      });
    });

    it("Test guess() function return values.", function() {
      return bettingContract.guess.call(1).then(function(success) {
        assert.isTrue(success, "1 is valid guess, must be true.");

        return bettingContract.guess.call(4);
      }).then(function(success) {
        assert.isFalse(success, "4 is invalid guess, must be false.");

        return bettingContract.guess.call(3);
      }).then(function(success) {
        assert.isTrue(success, "3 is invalid guess, must be true.");
      });
    });

    it("Test total count increment", function() {
      bettingContract.guess(1);
      bettingContract.guess(3);
      bettingContract.guess(4); // lose

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
  });
});