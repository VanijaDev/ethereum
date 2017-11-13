var SelfDestructContract = artifacts.require("./SelfDestructContract.sol");

contract('SelfDestructContract', function(accounts) {
  it("test self destructon", () => {
    var sdc;

    return SelfDestructContract.deployed()
      .then(inst => {
        sdc = inst; 
        sdc.updateSomeString("Hello");
        return sdc.someString();
      })
      .then(str => {
        console.log(str);
        assert.equal(str, "Hello", "Error while updating someString value.");
      })
      .then(() => { 
        sdc.killTheContract();
        console.log("Contract is destroyed."); 
        })
      .then(() => { return sdc.someString() })
  });
});