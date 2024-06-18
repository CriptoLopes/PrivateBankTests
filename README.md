# PrivateBankTests 
#try to create a coverage test with REMIS https://remix.ethereum.org/#lang=en&optimize=false&runs=200&evmVersion=null

# PrivateBankTests

This repository contains tests for the PrivateBank smart contract.

## Running Tests

1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create a new file named `PrivateBank.sol` and paste the contract code.
3. Create a new file named `PrivateBank_test.sol` and paste the test code.
4. Compile the contract using the Solidity compiler.
5. Go to the `Solidity Unit Testing` tab and run the tests.

## Contract Code

```solidity
pragma solidity 0.8.20;

// SPDX-License-Identifier: MIT

contract PrivateBank {
    mapping(address => uint256) private balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 balance = getUserBalance(msg.sender);

        require(balance > 0, "Insufficient balance");

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");

        balances[msg.sender] = 0;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getUserBalance(address _user) public view returns (uint256) {
        return balances[_user];
    }
}
