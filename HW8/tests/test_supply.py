import pytest
from brownie import VolcanoCoin, accounts

@pytest.fixture
def volcano_coin():
	return accounts[0].deploy(VolcanoCoin, accounts[0], 10000)
	
def test_supply(volcano_coin):
	assert volcano_coin.total_supply == 10000