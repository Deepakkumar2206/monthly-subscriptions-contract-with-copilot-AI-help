// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Subscription.sol";

contract SubscriptionTest is Test {
    Subscription public sub;
    address user = address(0x123);

    // 🔹 allow this test contract to receive ETH
    receive() external payable {}

    function setUp() public {
        sub = new Subscription(1 ether);
    }

    function testSubscribe() public {
        vm.deal(user, 10 ether);
        vm.prank(user);
        sub.subscribe{value: 1 ether}();

        assertGt(sub.nextPaymentDue(user), block.timestamp);
    }

    function testRenew() public {
        vm.deal(user, 10 ether);
        vm.prank(user);
        sub.subscribe{value: 1 ether}();

        vm.warp(block.timestamp + 31 days);

        vm.prank(user);
        sub.renew{value: 1 ether}();

        assertGt(sub.nextPaymentDue(user), block.timestamp);
    }

    function testWithdraw() public {
        vm.deal(user, 10 ether);
        vm.prank(user);
        sub.subscribe{value: 1 ether}();

        uint256 balBefore = address(this).balance;

        // Owner withdraws funds
        sub.withdraw();

        uint256 balAfter = address(this).balance;
        assertGt(balAfter, balBefore);
    }

    function test_Revert_SubscribeWithWrongAmount() public {
        vm.deal(user, 1 ether);
        vm.prank(user);

        vm.expectRevert(bytes("Invalid payment"));
        sub.subscribe{value: 0.5 ether}();
    }

    function test_Revert_WithdrawAsNonOwner() public {
        vm.deal(user, 10 ether);
        vm.prank(user);
        sub.subscribe{value: 1 ether}();

        vm.prank(user);
        vm.expectRevert(bytes("Only owner"));
        sub.withdraw();
    }
}
