pragma solidity ^0.4.17;

contract SimpleWallet {

  struct Withdrawal {
    address to;
    uint amount;
  }

  struct Sender {
    bool allowed;
    uint amount_send;
    mapping(uint => Withdrawal) withdrawals;
  }

  address private owner;
  mapping(address => Sender) private isAllowedToSendFunds;

//  TESTING FUNCTIONS
  function testSender(address _addr) public constant returns(uint amount_send, address withdrawl_to, uint withdrawl_amount) {
    amount_send = isAllowedToSendFunds[_addr].amount_send;
    withdrawl_to = isAllowedToSendFunds[_addr].withdrawals[amount_send].to;
    withdrawl_amount = isAllowedToSendFunds[_addr].withdrawals[amount_send].amount;
  }

//  MODIFIERS
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

//  EVENTS
  event LogDeposit(address _sender, uint _amount);
  event LogWithdrawal(address _sender, uint _amount, address _beneficiary);

  function SimpleWallet() public {
    owner = msg.sender;
  }

  function() public payable {
    require(msg.sender == owner || isAllowedToSendFunds[msg.sender].allowed);
    LogDeposit(msg.sender, msg.value);
  }

  function sendFunds(uint _amount, address _receiver) public returns(uint newBalance) {
    require(isAllowedToSend(msg.sender));
    require(this.balance >= _amount);

    _receiver.transfer(_amount);

    isAllowedToSendFunds[msg.sender].amount_send += 1;

    Withdrawal memory withdrawal = Withdrawal(_receiver, _amount);
    withdrawal.to = _receiver;
    withdrawal.amount = _amount;
    isAllowedToSendFunds[msg.sender].withdrawals[isAllowedToSendFunds[msg.sender].amount_send] = withdrawal;

    LogWithdrawal(msg.sender, _amount, _receiver);

    newBalance = this.balance;
  }

  function allowAddressToSendFunds(address _address) public onlyOwner returns(bool) {
    isAllowedToSendFunds[_address].allowed = true;

    return true;
  }

  function disallowAddressToSendFunds(address _address) public onlyOwner returns(bool) {
    isAllowedToSendFunds[_address].allowed = false;

    return true;
  }

  function isAllowedToSend(address _address) public view returns(bool isAllowed) {
    return (_address == owner || isAllowedToSendFunds[_address].allowed);
  }

  function killWallet() public onlyOwner {
    selfdestruct(owner);
  }
}
