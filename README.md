# 🎯 Loyalty Program Smart Contract System

A decentralized loyalty program management system built on Ethereum using Solidity and Foundry. This system allows businesses to create and manage their own loyalty programs with point-based rewards.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
- [Testing](#testing)
- [Deployment](#deployment)
- [Usage Examples](#usage-examples)
- [Contract Reference](#contract-reference)
- [Verification](#verification)

## 🌟 Overview

The Loyalty Program System consists of two main smart contracts:

1. **LoyaltyProgramFactory**: A factory contract that allows anyone to create their own loyalty program
2. **LoyaltyProgram**: Individual loyalty program contracts that manage points, users, and rewards

### Key Benefits

- ✅ **Decentralized**: No central authority controls the programs
- ✅ **Permissionless**: Anyone can create a loyalty program
- ✅ **Transparent**: All transactions are on-chain and verifiable
- ✅ **Secure**: Built-in access controls and ownership management
- ✅ **Scalable**: Factory pattern allows unlimited program creation

## 🚀 Features

### LoyaltyProgramFactory

- Create unlimited loyalty programs
- Track all created programs
- Track programs by owner
- Event emission for program creation
- Ownership management with OpenZeppelin

### LoyaltyProgram

- **Points Management**: Add and redeem points for users
- **User Enrollment**: Automatic enrollment on first point allocation
- **Access Control**: Only program owner can manage points
- **User Statistics**: Track total enrolled users
- **Self-Service**: Users can check their own points

## 🛠️ Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/hoangy761/loyalty-program.git
cd loyalty-program

# Install dependencies
forge install

# Build contracts
forge build
```

## 🧪 Testing

The project includes comprehensive tests covering various scenarios:

### Run All Tests

```bash
forge test
```

### Run Tests with Console Output

```bash
forge test -vv
```

### Run Specific Test

```bash
# Test factory and ownership scenarios
forge test --match-test testUserADeploysFactoryUserBCreatesProgram -vv

# Test program tracking functionality
forge test --match-test testTrackingProgramsByFactory -vv

# Test multiple users creating programs
forge test --match-test testMultipleUsersCreatePrograms -vv
```

### Test Coverage

Our tests cover:

- ✅ Factory deployment and ownership
- ✅ Loyalty program creation by different users
- ✅ Ownership transfer to program creators
- ✅ Points addition and redemption
- ✅ User enrollment tracking
- ✅ Access control enforcement
- ✅ Program tracking by factory
- ✅ Multiple program creation scenarios

## 🚀 Deployment

### Deploy to U2U Testnet

```bash
forge create \
  --rpc-url https://rpc-nebulas-testnet.uniultra.xyz \
  --private-key YOUR_PRIVATE_KEY \
  src/LoyaltyProgramFactory.sol:LoyaltyProgramFactory \
  --broadcast
```

## 📖 Usage Examples

### 1. Creating a Loyalty Program

```solidity
// Deploy or connect to factory
LoyaltyProgramFactory factory = LoyaltyProgramFactory(FACTORY_ADDRESS);

// Create your loyalty program (you become the owner)
LoyaltyProgram myProgram = factory.createLoyaltyProgram();
```

### 2. Managing Points

```solidity
// Add points to a customer (only owner can do this)
myProgram.addPoints(customerAddress, 100);

// Redeem points
myProgram.redeemPoints(customerAddress, 50);

// Check customer points
uint32 points = myProgram.points(customerAddress);
```

### 3. Viewing Program Statistics

```solidity
// Check total enrolled users
uint32 totalUsers = myProgram.getTotalUsers();

// Check if user is enrolled
bool isEnrolled = myProgram.isEnrolled(customerAddress);

// Get all programs created by factory
address[] memory allPrograms = factory.getAllPrograms();

// Get programs created by specific owner
address[] memory myPrograms = factory.getProgramsByOwner(ownerAddress);
```

## 📚 Contract Reference

### LoyaltyProgramFactory

#### Functions

- `createLoyaltyProgram()` → `LoyaltyProgram`: Creates new loyalty program
- `getAllPrograms()` → `address[]`: Returns all created program addresses
- `getProgramsByOwner(address)` → `address[]`: Returns programs created by owner
- `getProgramsCount()` → `uint32`: Returns total number of programs created

#### Events

- `LoyaltyProgramCreated(address indexed creator, address indexed programAddress, uint32 programIndex)`

### LoyaltyProgram

#### Functions

- `addPoints(address user, uint32 amount)`: Add points to user (onlyOwner)
- `redeemPoints(address user, uint32 amount)`: Redeem points from user (onlyOwner)
- `getMyPoints()` → `uint32`: Get caller's points
- `getTotalUsers()` → `uint32`: Get total enrolled users count

#### Public Variables

- `points(address)` → `uint32`: Points balance for each user
- `isEnrolled(address)` → `bool`: Enrollment status for each user

## 🔍 Verification

### Automated Verification (Command Line)

```bash -- [PENDING :3]
# Replace CONTRACT_ADDRESS with your actual deployed contract address
forge verify-contract \
  --chain-id 2484 \
  --verifier-url https://testnet.u2uscan.xyz \
  --etherscan-api-key dummy_key \
  CONTRACT_ADDRESS \
  src/LoyaltyProgramFactory.sol:LoyaltyProgramFactory

```

**Note**: Automated verification may not work with U2U explorer due to API compatibility issues. Use manual verification if the command fails.

### Manual Verification on U2U Explorer

1. Go to [U2U Testnet Explorer](https://testnet.u2uscan.xyz/)
2. Find your deployed contract
3. Click "Contract" → "Verify & Publish"
4. Use the flattened source code:

```bash
forge flatten src/LoyaltyProgramFactory.sol > LoyaltyProgramFactory_flattened.sol
```

### Verification Details

- **Compiler Version**: `v0.8.28`
- **License**: MIT
- **Optimization**: Enabled (default in Foundry)

## 🌐 Deployed Contracts

### U2U Testnet

- **Factory Contract**: `0x08681814b882dA67F1FEbC69cE2802a1Ec76f12F`
- **Chain ID**: `2484`
- **Explorer**: [U2U Testnet Explorer](https://testnet.u2uscan.xyz/)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the contract files for details.

## 🛡️ Security Considerations

- All contracts use OpenZeppelin's security-audited implementations
- Access control enforced through `onlyOwner` modifiers
- Integer overflow protection with Solidity 0.8+
- Comprehensive test coverage for edge cases

## 🆘 Support

For questions and support:

- Create an issue in this repository
- Review the test files for usage examples
- Check the Foundry documentation: https://book.getfoundry.sh/

---

Built with ❤️ using [Foundry](https://getfoundry.sh/) and [OpenZeppelin](https://openzeppelin.com/)
