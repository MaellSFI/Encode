import pytest
from brownie import VolcanoCoin, accounts, reverts

@pytest.fixture(scope='module')
def volcano_coin():
	return accounts[0].deploy(VolcanoCoin, accounts[0], 10000)
	
def test_supply(volcano_coin):
	assert volcano_coin.get_total_supply() == 10000

def test_increase(volcano_coin):
	for x in range(1,6):
		volcano_coin.increase_supply()
		assert volcano_coin.get_total_supply() == (10000 + (x*1000))
		
def test_owner_only(volcano_coin):
	
	with reverts():
		volcano_coin.increase_supply({"from": accounts[1]})
