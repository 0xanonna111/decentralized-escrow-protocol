// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title Escrow
 * @dev A secure, state-managed escrow contract for Web3 transactions.
 */
contract Escrow is ReentrancyGuard {
    enum State { AWAITING_PAYMENT, AWAITING_DELIVERY, CLOSED, DISPUTED }
    
    address public buyer;
    address public seller;
    address public arbitrator;
    uint256 public amount;
    State public currentState;

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer");
        _;
    }

    modifier onlyArbitrator() {
        require(msg.sender == arbitrator, "Only arbitrator");
        _;
    }

    constructor(address _seller, address _arbitrator) {
        buyer = msg.sender;
        seller = _seller;
        arbitrator = _arbitrator;
        currentState = State.AWAITING_PAYMENT;
    }

    function deposit() external payable onlyBuyer {
        require(currentState == State.AWAITING_PAYMENT, "Already paid");
        require(msg.value > 0, "Amount must be > 0");
        amount = msg.value;
        currentState = State.AWAITING_DELIVERY;
    }

    function confirmDelivery() external onlyBuyer nonReentrant {
        require(currentState == State.AWAITING_DELIVERY, "Not in delivery state");
        currentState = State.CLOSED;
        (bool success, ) = payable(seller).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function initiateDispute() external {
        require(msg.sender == buyer || msg.sender == seller, "Unauthorized");
        require(currentState == State.AWAITING_DELIVERY, "Cannot dispute now");
        currentState = State.DISPUTED;
    }

    function resolveDispute(uint256 buyerAmount, uint256 sellerAmount) external onlyArbitrator nonReentrant {
        require(currentState == State.DISPUTED, "No active dispute");
        require(buyerAmount + sellerAmount == amount, "Invalid split");

        currentState = State.CLOSED;
        if (buyerAmount > 0) payable(buyer).transfer(buyerAmount);
        if (sellerAmount > 0) payable(seller).transfer(sellerAmount);
    }
}
