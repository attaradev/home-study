// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";

// Author: @mikeattara

contract Bank {
    struct Account {
        uint balance;
        address payable owner;
    }

    mapping(address => Account) accounts;

    event Withdrawal(address owner, uint amount, uint when);
    event Deposit(address owner, uint amount, uint when);
    event Transfer(address from, address to, uint amount, uint when);

    constructor() payable {
        accounts[msg.sender].owner = payable(msg.sender);
        accounts[msg.sender].balance = msg.value;
    }

    function deposit() public payable {
        require(msg.value >= 1, "You can't deposit less than 1 wei");

        if (accounts[msg.sender].balance == 0) {
            accounts[msg.sender].owner = payable(msg.sender);
        }

        accounts[msg.sender].balance += msg.value;

        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    function getBalance() public view returns (uint) {
        return accounts[msg.sender].balance;
    }

    function transfer(address to, uint amount) public {
        require(amount >= 1, "You can't transfer less than 1 wei");
        require(
            accounts[msg.sender].balance >= amount,
            "You don't have enough funds"
        );

        accounts[msg.sender].balance -= amount;
        accounts[to].balance += amount;

        emit Transfer(msg.sender, to, amount, block.timestamp);
    }

    function withdraw(uint amount) public {
        require(amount >= 1, "You can't withdraw less than 1 wei");
        require(
            accounts[msg.sender].balance >= amount,
            "You don't have enough funds"
        );
        accounts[msg.sender].balance -= amount;
        accounts[msg.sender].owner.transfer(amount);

        emit Withdrawal(msg.sender, amount, block.timestamp);
    }
}
