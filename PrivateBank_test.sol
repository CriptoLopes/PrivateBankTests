// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "remix_tests.sol"; // this import is automatically injected by Remix.
import "./PrivateBank.sol";

contract PrivateBankTest {
    PrivateBank privateBank;
    address testAddress;

    // Before each test
    function beforeEach() public {
        privateBank = new PrivateBank();
        testAddress = address(this);
    }

    // Test deposit function
    function testDeposit() public {
        privateBank.deposit{value: 1 ether}();
        Assert.equal(privateBank.getUserBalance(testAddress), 1 ether, "Deposit of 1 ether failed");
    }

    // Test withdraw function
    function testWithdraw() public {
        privateBank.deposit{value: 1 ether}();
        privateBank.withdraw();
        Assert.equal(privateBank.getUserBalance(testAddress), 0, "Withdraw failed");
        Assert.equal(testAddress.balance, 1 ether, "Withdraw failed to send ether");
    }

    // Test getBalance function
    function testGetBalance() public {
        Assert.equal(privateBank.getBalance(), 0, "Initial balance is not zero");
        privateBank.deposit{value: 1 ether}();
        Assert.equal(privateBank.getBalance(), 1 ether, "Deposit of 1 ether failed");
    }

    // Test getUserBalance function
    function testGetUserBalance() public {
        Assert.equal(privateBank.getUserBalance(testAddress), 0, "Initial user balance is not zero");
        privateBank.deposit{value: 1 ether}();
        Assert.equal(privateBank.getUserBalance(testAddress), 1 ether, "User balance after deposit is not correct");
    }

    // Test withdraw with insufficient balance
    function testWithdrawInsufficientBalance() public {
        try privateBank.withdraw() {
            Assert.ok(false, "Withdraw should have failed due to insufficient balance");
        } catch Error(string memory reason) {
            Assert.equal(reason, "Insufficient balance", "Unexpected error message");
        }
    }

    // Test multiple deposits and withdrawals
    function testMultipleDepositsWithdrawals() public {
        privateBank.deposit{value: 1 ether}();
        privateBank.deposit{value: 2 ether}();
        Assert.equal(privateBank.getUserBalance(testAddress), 3 ether, "Multiple deposits failed");

        privateBank.withdraw();
        Assert.equal(privateBank.getUserBalance(testAddress), 0, "Withdraw after multiple deposits failed");
        Assert.equal(testAddress.balance, 3 ether, "Withdraw failed to send ether after multiple deposits");
    }

    // Test deposit and withdraw by different user
    function testDifferentUser() public {
        address otherUser = address(0x123);
        privateBank.deposit{value: 1 ether}();
        Assert.equal(privateBank.getUserBalance(testAddress), 1 ether, "Deposit by test address failed");

        // Try withdraw by another address
        (bool success, ) = address(privateBank).call(abi.encodeWithSignature("withdraw()"));
        Assert.equal(success, false, "Withdraw by other user should have failed");
    }
}
