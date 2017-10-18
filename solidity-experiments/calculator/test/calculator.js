var Calculator = artifacts.require("./Calculator.sol");
contract('Calculator', function(accounts) {
  
  // Test Case#1
  describe("Test case #1 - initial value, add, substract, multiply, divide operations.", function() {
    beforeEach(function() {
      console.log("New test starts.");
    });

    var calculator;

    it("Test initial value.", function() {

      return Calculator.deployed().then(function(instance) {
        calculator = instance;

        return calculator.getResult.call();
      }).then(function(result) {
        //  Test: Contract should be initialized with 10
        assert.equal(result.valueOf(), 10, "Contract initialized with value NOT equal to 10!");
      });
    });

    it("Test add & substract", function() {
      calculator.addToNumber(10);

      return calculator.getResult.call().then(function(result) {
        assert.equal(result.valueOf(), 20, "Result after add is not 20!");
  
        calculator.substractFromNumber(5);
        return calculator.getResult.call();
      }).then(function(result) {
        assert.equal(result.valueOf(), 15, "Result after substract is not 15!");
      });
    });

    it("Test multiply & divide", function() {
      calculator.multiplyWithNumber(3);

      return calculator.getResult.call().then(function(result) {
        assert.equal(result.valueOf(), 45, "Result after multiply is not 45!");

        calculator.divideByNumber(5);
        return calculator.getResult.call();
      }).then(function(result) {
        assert.equal(result.valueOf(), 9, "Result after divide is not 9!");
      });
    });

    it("Test double & half", function() {
      calculator.double();

      return calculator.getResult.call().then(function(result) {
        assert.equal(result.valueOf(), 18, "Result after double is not 18!");

        calculator.half();
        return calculator.getResult.call();
      }).then(function(result) {
        assert.equal(result.valueOf(), 9, "Result after half is not 9!");
      });
    });

  });
}); 

