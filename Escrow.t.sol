// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./Escrow.sol";

contract EscrowTest is Test {
    Escrow public escrow;
    address buyer = address(0x1);
    address seller = address(0x2);
    address arb = address(0x3);

    function setUp() public {
        vm.prank(buyer);
        escrow = new Escrow(seller, arb);
    }

    function testFullFlow() public {
        vm.deal(buyer, 1 ether);
        vm.startPrank(buyer);
        escrow.deposit{value: 1 ether}();
        escrow.confirmDelivery();
        vm.stopPrank();

        assertEq(seller.balance, 1 ether);
    }

    function testDisputeResolution() public {
        vm.deal(buyer, 1 ether);
        vm.prank(buyer);
        escrow.deposit{value: 1 ether}();
        
        vm.prank(seller);
        escrow.initiateDispute();
        
        vm.prank(arb);
        escrow.resolveDispute(0.5 ether, 0.5 ether);

        assertEq(buyer.balance, 0.5 ether);
        assertEq(seller.balance, 0.5 ether);
    }
}
