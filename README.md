## Subscription Contract (AI-Powered Development)
### Overview
- This project demonstrates how to build and test a monthly subscription smart contract using Foundry.
- It was developed with the help of AI tools - ChatGPT-5 and GitHub Copilot integrated in VSCode.
- ChatGPT-5 provided structured contract design, explained reverts, and suggested fixes (e.g. adding a receive() function).
- GitHub Copilot - auto-completed functions, generated test stubs, and even suggested corrections when tests reverted.
- AI Debugging - Copilot + ChatGPT identified why withdraw() reverted and corrected it automatically.

This project shows how AI can accelerate blockchain development by guiding coding, debugging, and testing in real-time.

### Smart Contract: Subscription.sol
- Users can subscribe by paying the monthly fee.
- Users can renew subscriptions each month.
- Contract owner can withdraw collected funds.
- Events track all actions for transparency.

### Tests: Subscription.t.sol
- testSubscribe() - ensures new subscription works.
- testRenew() - checks renewal after 31 days.
- testWithdraw() - verifies owner can withdraw ETH.
- test_Revert_SubscribeWithWrongAmount() - reverts on incorrect payment.
- test_Revert_WithdrawAsNonOwner() - reverts if non-owner tries withdrawal.

We added receive() in the test contract to accept ETH - this was suggested by Copilot’s error analysis when the withdraw test failed.

### Commands

```shell
# Install dependencies
forge install foundry-rs/forge-std

# Build contracts
forge build

# Run tests (verbose)
forge test -vv
```

### Sample Outputs

```shell
Ran 5 tests for test/Subscription.t.sol:SubscriptionTest
[PASS] testRenew() (gas: 58115)
[PASS] testSubscribe() (gas: 46463)
[PASS] testWithdraw() (gas: 56301)
[PASS] test_Revert_SubscribeWithWrongAmount() (gas: 21408)
[PASS] test_Revert_WithdrawAsNonOwner() (gas: 49130)
Suite result: ok. 5 passed; 0 failed
```

## End of the Project


