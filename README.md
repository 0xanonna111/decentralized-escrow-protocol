# Decentralized Escrow Protocol

A high-quality, secure escrow service designed for peer-to-peer transactions. This protocol allows a buyer to deposit funds into a contract, which are then held until the buyer confirms receipt or an appointed arbitrator resolves a dispute.

## Core Logic
- **Deposit**: Buyer locks funds into the contract.
- **Release**: Buyer confirms satisfaction, releasing funds to the Seller.
- **Dispute**: Either party can trigger a dispute, allowing the Arbitrator to decide the fund allocation.

## Security Features
- **Pull over Push**: Implements a secure withdrawal pattern.
- **State Machine**: Uses defined states (Created, Locked, Released, Disputed) to prevent logic errors.
- **Arbitration**: Neutral third-party address for conflict resolution.

## License
MIT
