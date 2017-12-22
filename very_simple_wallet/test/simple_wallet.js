const SimpleWallet = artifacts.require('./SimpleWallet.sol');
const Asserts = require('./helpers/asserts');

contract('SimpleWallet', (accounts) => {
  let wallet;

  const asserts = Asserts(assert);

  const OWNER = accounts[0];
  const ACC_1 = accounts[1];
  const ACC_2 = accounts[2];
  const ACC_3 = accounts[3];

  before('setup', async () => {
    let inst = await SimpleWallet.deployed();
    wallet = inst;
  });

  afterEach('reset state', async () => {
    let inst = await SimpleWallet.new();
    wallet = inst;
  });

  it('owner is allowed to send funds', async () => {
    let allowed = await wallet.isAllowedToSend.call(OWNER);
    assert.isTrue(allowed, 'owner should be allowed to send');
  });

  it('other accs are not allowed to send funds', async () => {
    let allowed = await wallet.isAllowedToSend.call(ACC_1);
    assert.isFalse(allowed, 'owner should be allowed to send');
  });

  it('only owner can add / remove accounts to allowance list', async () => {
    //  test return value
    let allowResult = await wallet.allowAddressToSendFunds.call(ACC_1);
    assert.isTrue(allowResult, 'should be true after owner request to allow CALL');

    allowResult = await wallet.disallowAddressToSendFunds.call(ACC_1);
    assert.isTrue(allowResult, 'should be true after owner request to disallow CALL');

    //  make tx
    await wallet.allowAddressToSendFunds(ACC_2);
    let allowed = await wallet.isAllowedToSend.call(ACC_2);
    assert.isTrue(allowed, 'should be allowed');
    
    await wallet.disallowAddressToSendFunds(ACC_2);
    allowed = await wallet.isAllowedToSend.call(ACC_2);
    assert.isFalse(allowed, 'should be disallowed');
  });

  it('check Deposit event', async () => {
    const amount = 1000000;
    let tx = await wallet.sendTransaction({from: OWNER, value: amount});
    assert.equal(tx.logs.length, 1, 'must be 1 log');
    
    let LogDeposit = tx.logs[0];
    assert.equal(LogDeposit.event, 'LogDeposit');
    assert.equal(LogDeposit.args._sender, OWNER, 'should be owner address');
    assert.equal(LogDeposit.args._amount, amount, 'should be as amount');
  });

  it('owner can deposit', async () => {
    const amount = 1000000;
    await wallet.sendTransaction({from: OWNER, value: amount});
    assert.equal(web3.eth.getBalance(wallet.address), amount, 'should be qual to amount');
  });
  
  it('not owner can not deposit', async () => {
    const amount = 1000000;
    await asserts.throws(wallet.sendTransaction({from: ACC_1, value: amount}));
  });

  describe('sendFunds', () => {
    const walletFundAmount = 222222;
    const sendFundAmount = walletFundAmount / 2;

    beforeEach('deposit wallet', async () => {
      await wallet.sendTransaction({from: OWNER, value: walletFundAmount});
    });

    it('LogWithdrawal is sent', async () => {
      let tx = await wallet.sendFunds(sendFundAmount, ACC_1);
  
      assert.equal(tx.logs.length, 1, 'only one event must be sent');
      let log = tx.logs[0];
      assert.equal(log.event, 'LogWithdrawal', 'wrong event');
      assert.equal(log.args._sender, OWNER, 'wrong sender');
      assert.equal(log.args._amount, sendFundAmount, 'wrong send amount');
      assert.equal(log.args._beneficiary, ACC_1, 'wrong beneficiary');
    });

    it('isAllowedToSendFunds mapping updated', async () => {
      await wallet.sendFunds(sendFundAmount, ACC_1);

      let testSenderResult = await wallet.testSender.call(OWNER);
      assert.equal(testSenderResult[0].toNumber(), 1, 'amount_send should be 1');    
      assert.equal(testSenderResult[1], ACC_1, 'withdrawl_to should be ACC_1');
      assert.equal(testSenderResult[2].toNumber(), sendFundAmount, 'withdrawl_amount should be ' + sendFundAmount)  
    });
  });
  
});