// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Subscription Contract
/// @notice Handles monthly subscription payments
contract Subscription {
    address public owner;
    uint256 public monthlyFee;
    mapping(address => uint256) public nextPaymentDue;

    event Subscribed(address indexed user, uint256 nextPayment);
    event Renewed(address indexed user, uint256 nextPayment);
    event Withdrawn(address indexed owner, uint256 amount);

    constructor(uint256 _monthlyFee) {
        owner = msg.sender;
        monthlyFee = _monthlyFee;
    }

    /// @notice Subscribe for the first time
    function subscribe() external payable {
        require(msg.value == monthlyFee, "Invalid payment");
        require(nextPaymentDue[msg.sender] == 0, "Already subscribed");

        nextPaymentDue[msg.sender] = block.timestamp + 30 days;
        emit Subscribed(msg.sender, nextPaymentDue[msg.sender]);
    }

    /// @notice Renew subscription after it’s close to expiry
    function renew() external payable {
        require(msg.value == monthlyFee, "Invalid payment");
        require(nextPaymentDue[msg.sender] > 0, "Not subscribed");
        require(block.timestamp >= nextPaymentDue[msg.sender] - 1 days, "Too early");

        nextPaymentDue[msg.sender] += 30 days;
        emit Renewed(msg.sender, nextPaymentDue[msg.sender]);
    }

    /// @notice Withdraw collected fees
    function withdraw() external {
        require(msg.sender == owner, "Only owner");
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds");

        payable(owner).transfer(balance);
        emit Withdrawn(owner, balance);
    }
}
