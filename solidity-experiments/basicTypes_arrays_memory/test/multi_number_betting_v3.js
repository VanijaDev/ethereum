/**
  This is a copy of multi_number_betting_v2 + new functional
 */

var MultiNumberBettingV3 = artifacts.require("./MultiNumberBettingV3.sol");

contract('MultiNumberBettingV3', function(accounts) {
  
  var bettingContract;

  describe("Initial tests", function() {
    beforeEach(function() {
      console.log("New test.");
    });

    it("MultiNumberBettingV3 initialize.", function() {
      return MultiNumberBettingV3.deployed().then(function(instance) {
        assert.notEqual(instance, null, "Contract must be initialized.");

        bettingContract = instance;

        return bettingContract.totalGuesses.call();
      }).then(function(totalGuesses) {
        assert.equal(totalGuesses.valueOf(), 0, "Initial total guesses should be 0.");

        return bettingContract.getLastWinnerName.call();
      }).then(function(name) {
        assert.equal(name, "***", "No winner name yet, must be '***' string.");

        return bettingContract.lastWinnerAt.call();
      }).then(function(time) {
        assert.isTrue(time.valueOf() == 0, "No winners yet. Must be 0.");

        return bettingContract.lastWinnerAddress.call();
      }).then(function(address) {
        assert.isTrue(address == 0x0, "No winners yet. Must be 0x0.");
      });

      it("Time since last win functions initial test.", function() {
        return bettingContract.daysSinceLastWinning.call().then(function(days) {
          assert.equal(days.valueOf(), 0, "No winners yet. Days must be 0.");
          
          return bettingContract.hoursSinceLastWinning.call();
        }).then(function(hours) {
          assert.equal(hours.valueOf(), 0, "No winners yet. Hours must be 0.");
          
          return bettingContract.minutesSinceLastWinning.call();
        }).then(function(minutes) {
          assert.equal(minutes.valueOf(), 0, "No winners yet. Minutes must be 0.");
        });
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

    it("Test total count increment, winner address, time since winner.", function() {
      return MultiNumberBettingV3.deployed().then(function(instance) {
        assert.notEqual(instance, null, "Contract must be initialized.");

        bettingContract = instance;

        bettingContract.guess(1, "Ivan");
        bettingContract.guess(3, "Oleg");
        bettingContract.guess(4, "Igor"); // lose

        return bettingContract.totalGuesses.call();
      }).then(function(totalGuesses) {
        assert.equal(totalGuesses.valueOf(), 3, "totalGuesses must be 3.");
        
      }).then(function() {

        return bettingContract.loserCount.call();
      }).then(function(loses) {
        assert.equal(loses.toNumber(), 1, "loses must be 1.");

        return bettingContract.winnerCount.call();
      }).then(function(wins) {
        assert.equal(wins.valueOf(), 2, "wins must be 2.");

        return bettingContract.lastWinnerAt.call();
      }).then(function(winnerAt) {
        assert.isTrue(winnerAt.valueOf() > 0, "There were winners. Must be > 0.");

        return bettingContract.lastWinnerAddress.call();
      }).then(function(addr) {
        assert.isTrue(addr != 0x0, "There were winners. address must exist.");
      })

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