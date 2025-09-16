# PredictaMax: Advanced Cryptocurrency Price Prediction Platform

[![Clarity Version](https://img.shields.io/badge/Clarity-3.1-blue)](https://docs.stacks.co/clarity)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-Vitest-yellow)](vitest.config.js)

## Overview

PredictaMax is a sophisticated decentralized prediction market built on the Stacks blockchain, enabling users to forecast Bitcoin price movements through competitive staking mechanisms. The platform combines blockchain transparency with advanced market mechanics, featuring automated reward distribution and oracle-based price resolution.

### Key Features

- **Binary Price Predictions**: Users stake STX tokens on Bitcoin price direction (up/down)
- **Time-Bounded Markets**: Prediction windows with defined start and end blocks
- **Proportional Rewards**: Winners share the total stake pool based on their contribution
- **Oracle Integration**: Trusted price feeds ensure accurate market resolution
- **Fee Management**: Configurable platform fees with automated collection
- **Administrative Controls**: Owner functions for platform governance

## Architecture

### Smart Contract Structure

```
PredictaMax Contract
├── Constants & Error Definitions
├── Data Variables (Oracle, Fees, Minimums)
├── Data Maps (Markets, User Predictions)
├── Public Functions
│   ├── Market Management
│   ├── Prediction Placement
│   ├── Market Resolution
│   └── Reward Claims
├── Read-Only Functions
└── Administrative Functions
```

### Core Components

#### 1. Market Management System

- **Market Creation**: Owner-only function to initialize new prediction markets
- **Market Resolution**: Oracle-triggered resolution with final price data
- **State Tracking**: Comprehensive market state management

#### 2. Prediction Engine

- **Stake Validation**: Minimum stake requirements and balance checks
- **Prediction Recording**: Immutable prediction storage with stake amounts
- **Market Participation**: Real-time stake aggregation for both directions

#### 3. Reward Distribution

- **Winner Calculation**: Automated winner determination based on price movement
- **Proportional Payouts**: Fair distribution based on stake ratios
- **Fee Deduction**: Platform fee calculation and collection

#### 4. Oracle Integration

- **Price Resolution**: Trusted oracle provides final Bitcoin prices
- **Access Control**: Oracle-only resolution permissions
- **Data Validation**: Price data integrity checks

### Data Models

#### Market Structure

```clarity
{
  start-price: uint,      // Initial Bitcoin price
  end-price: uint,        // Final Bitcoin price (set by oracle)
  total-up-stake: uint,   // Total STX staked on price increase
  total-down-stake: uint, // Total STX staked on price decrease
  start-block: uint,      // Market opening block
  end-block: uint,        // Market closing block
  resolved: bool          // Resolution status
}
```

#### User Prediction Structure

```clarity
{
  prediction: string-ascii, // "up" or "down"
  stake: uint,             // Amount staked in STX
  claimed: bool            // Reward claim status
}
```

### Security Model

#### Access Controls

- **Contract Owner**: Market creation, administrative functions
- **Oracle Address**: Market resolution authority
- **Users**: Prediction placement, reward claims

#### Validation Mechanisms

- **Timing Constraints**: Block-based market windows
- **Balance Verification**: Sufficient STX balance checks
- **State Validation**: Market resolution and claim prevention
- **Parameter Bounds**: Minimum stakes and fee limits

## Installation & Setup

### Prerequisites

- [Clarinet CLI](https://docs.hiro.so/stacks/clarinet) v2.0+
- [Node.js](https://nodejs.org/) v18+
- [TypeScript](https://www.typescriptlang.org/) v5.0+

### Local Development

1. **Clone the repository**

   ```bash
   git clone https://github.com/abass-jamiu/predicta-max.git
   cd predicta-max
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Run contract checks**

   ```bash
   clarinet check
   ```

4. **Execute tests**

   ```bash
   npm test
   ```

5. **Start development console**

   ```bash
   clarinet console
   ```

## Usage Guide

### Contract Deployment

```bash
# Deploy to devnet
clarinet deploy --devnet

# Deploy to testnet
clarinet deploy --testnet
```

### Function Reference

#### Market Creation (Owner Only)

```clarity
(create-market 
  u5000000  ;; start-price (50,000 satoshis)
  u1000     ;; start-block
  u2000)    ;; end-block
```

#### Placing Predictions

```clarity
(make-prediction 
  u0           ;; market-id
  "up"         ;; prediction ("up" or "down")
  u10000000)   ;; stake amount (10 STX)
```

#### Market Resolution (Oracle Only)

```clarity
(resolve-market 
  u0           ;; market-id
  u5500000)    ;; end-price (55,000 satoshis)
```

#### Claiming Rewards

```clarity
(claim-winnings u0) ;; market-id
```

### Administrative Functions

#### Oracle Management

```clarity
(set-oracle-address 'SP...)  ;; New oracle principal
```

#### Fee Configuration

```clarity
(set-fee-percentage u3)      ;; 3% platform fee
(set-minimum-stake u2000000) ;; 2 STX minimum
```

#### Revenue Collection

```clarity
(withdraw-fees u1000000)     ;; Withdraw 1 STX in fees
```

## Error Codes

| Code | Description |
|------|-------------|
| u100 | Owner-only function access |
| u101 | Market or prediction not found |
| u102 | Invalid prediction parameters |
| u103 | Market closed or timing error |
| u104 | Rewards already claimed |
| u105 | Insufficient STX balance |
| u106 | Invalid function parameters |

## Testing Framework

The project uses Vitest with Clarinet SDK for comprehensive testing:

```bash
# Run all tests
npm test

# Generate coverage report
npm run test:report

# Watch mode for development
npm run test:watch
```

### Test Structure

- **Unit Tests**: Individual function validation
- **Integration Tests**: End-to-end market scenarios
- **Edge Cases**: Error conditions and boundary testing

## Economics & Tokenomics

### Revenue Model

- **Platform Fees**: 2% default fee on winning payouts
- **Fee Collection**: Automated transfer to contract owner
- **Adjustable Rates**: Owner-configurable fee percentages (0-100%)

### Stake Mechanics

- **Minimum Stakes**: 1 STX default minimum
- **Proportional Rewards**: Winner share = (user_stake / total_winning_stake) × total_pool
- **Fee Deduction**: Applied to individual winnings before payout

### Example Payout Calculation

```
Market: Bitcoin $50,000 → $55,000 (UP wins)
Total UP stakes: 100 STX
Total DOWN stakes: 50 STX
User stake: 10 STX (UP)

Winnings = (10 ÷ 100) × 150 = 15 STX
Fee = 15 × 0.02 = 0.3 STX
Payout = 15 - 0.3 = 14.7 STX
```

## Security Considerations

### Smart Contract Security

- **Reentrancy Protection**: State updates before external calls
- **Integer Overflow**: Clarity's built-in safety mechanisms
- **Access Control**: Role-based function restrictions
- **State Validation**: Comprehensive assertion checks

### Oracle Dependencies

- **Trust Model**: Single oracle for price resolution
- **Data Integrity**: Price validation and sanity checks
- **Failure Handling**: Market remains open if oracle fails

### Operational Security

- **Owner Key Management**: Secure private key storage
- **Oracle Reliability**: Monitoring and backup procedures
- **Fee Management**: Regular withdrawal protocols

## Contributing

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Implement changes with tests
4. Run the full test suite
5. Submit a pull request

### Code Standards

- Follow Clarity best practices
- Maintain test coverage above 90%
- Document all public functions
- Use descriptive variable names

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Roadmap

### Phase 1 (Current)

- ✅ Core prediction market functionality
- ✅ Oracle integration
- ✅ Administrative controls

### Phase 2 (Upcoming)

- 🔄 Multi-asset prediction support
- 🔄 Advanced market types
- 🔄 Governance token integration

### Phase 3 (Future)

- 📋 Decentralized oracle network
- 📋 Cross-chain compatibility
- 📋 Mobile application interface

## Support

For technical support or questions:

- **Documentation**: [Stacks Documentation](https://docs.stacks.co/)
- **Community**: [Stacks Discord](https://discord.gg/stacks)
- **Issues**: [GitHub Issues](https://github.com/abass-jamiu/predicta-max/issues)

---

Built with ❤️ on Stacks blockchain using Clarity smart contracts.
