# @version >=0.3.2

event Transfer:
	amount: int128
	recipient: address
	
event SupplyIncrease:
	new_supply:	int128

struct Payment:
	recipient: address
	amount: int128

# Volcano Params
owner: public(address)
total_supply: public(int128)
supply_increment: int128
balances: public(HashMap[address, int128])
payments: HashMap[address, DynArray[Payment,1024]]

@external 
def __init__(_owner: address, _total_supply: int128):
	self.owner = _owner
	self.total_supply = _total_supply
	self.supply_increment = 1000
	self.balances[_owner] = _total_supply
	
@external
def increase_supply():
	assert msg.sender == self.owner
	self.total_supply += self.supply_increment
	log SupplyIncrease(self.total_supply) 

@view
@external
def get_total_supply() -> int128:
	return self.total_supply

@external
def transfer(_amount: int128, _recipient: address):
	assert _amount > 0
	assert self.balances[msg.sender] >= _amount
	
	self.balances[msg.sender] -= _amount
	self.balances[_recipient] += _amount
	
	log Transfer(_amount, _recipient)	
	self._record_payment(msg.sender, _recipient, _amount)
	
@external
@view 
def get_payments(_address: address) -> DynArray[Payment, 1024]:
	return self.payments[_address]
	
@internal
def _record_payment(_sender: address, _receiver: address, _amount: int128):
	self.payments[_sender].append(Payment({recipient:_receiver, amount:_amount}))	
	