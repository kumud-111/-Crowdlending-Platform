# Crowdlending Platform

A decentralized peer-to-peer lending platform built on Ethereum that enables users to create loan requests and fund loans with interest-based returns.

## Table of Contents
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Smart Contract Deployment](#smart-contract-deployment)
- [Frontend Setup](#frontend-setup)
- [Usage Guide](#usage-guide)
- [Contract Functions](#contract-functions)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)

## Features
- Create loan requests with customizable terms
- Fund loans with ETH
- Automatic interest calculation
- Multiple lenders per loan
- User-friendly interface
- Real-time updates
- MetaMask integration
- Platform fee system
- Responsive design

## Technology Stack
- Solidity ^0.8.0 (Smart Contract)
- Web3.js (Blockchain Interaction)
- HTML/CSS/JavaScript (Frontend)
- MetaMask (Wallet Connection)

## Prerequisites
- Node.js v14+ and npm
- MetaMask browser extension
- Some ETH for testing (can use testnet)
- Basic understanding of DeFi and smart contracts

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/crowdlending-platform.git
cd crowdlending-platform
```

2. Install dependencies:
```bash
npm install
```

## Smart Contract Deployment

1. Configure your deployment network in your preferred tool (Truffle/Hardhat):
```javascript
// truffle-config.js or hardhat.config.js
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    }
  },
  compilers: {
    solc: {
      version: "0.8.0"
    }
  }
};
```

2. Deploy the contract:
```bash
npx truffle migrate --network <your-network>
# or
npx hardhat run scripts/deploy.js --network <your-network>
```

3. Save the deployed contract address and ABI

## Frontend Setup

1. Update contract address in `index.html`:
```javascript
const contractAddress = 'YOUR_CONTRACT_ADDRESS_HERE';
```

2. Add contract ABI to the `contractABI` array

3. Serve the frontend:
```bash
npx http-server ./
```

## Usage Guide

### Borrowers

1. Connect Wallet:
   - Click "Connect Wallet"
   - Approve MetaMask connection

2. Create Loan Request:
   - Go to "Borrow" tab
   - Enter loan amount (ETH)
   - Set interest rate (%)
   - Define duration (days)
   - Click "Create Loan Request"

3. Repay Loan:
   - Go to "My Loans" tab
   - Find active loan
   - Click "Repay Loan"
   - Confirm transaction

### Lenders

1. View Available Loans:
   - Go to "Lend" tab
   - Browse active loan requests

2. Fund a Loan:
   - Enter funding amount
   - Click "Fund Loan"
   - Confirm transaction

3. Track Investments:
   - Monitor funded loans
   - Wait for repayment
   - Withdraw returns

## Contract Functions

### Core Functions
```solidity
// Create a new loan request
function createLoan(
    uint256 _amount,
    uint256 _interestRate,
    uint256 _duration
) external returns (uint256)

// Fund an existing loan
function fundLoan(uint256 _loanId) external payable
```

### Helper Functions
```solidity
// Repay an active loan
function repayLoan(uint256 _loanId) external payable

// Cancel unfunded loan
function cancelLoan(uint256 _loanId) external

// Withdraw lender returns
function withdrawLenderFunds(uint256 _loanId) external

// Get loan details
function getLoanDetails(uint256 _loanId) external view returns (...)
```

## Security Considerations

1. Fund Safety:
   - Funds locked in smart contract
   - Only borrower can repay loan
   - Only lenders can withdraw their share

2. Time Constraints:
   - Fixed loan duration
   - Automatic deadline calculation
   - No early withdrawals

3. Access Control:
   - Function modifiers for authorization
   - Borrower/lender role separation
   - Input validation

4. Economic Security:
   - Platform fee system
   - Interest rate limits
   - Minimum loan amounts

## Error Handling

Common errors and solutions:

1. Transaction Failed:
   - Check MetaMask network
   - Verify ETH balance
   - Confirm gas settings

2. Loan Creation Failed:
   - Verify input values
   - Check network connection
   - Ensure sufficient gas

3. Funding Failed:
   - Confirm loan is active
   - Check funding amount
   - Verify available balance

## Contributing

1. Fork the repository
2. Create feature branch:
```bash
git checkout -b feature/YourFeature
```
3. Commit changes:
```bash
git commit -m 'Add some feature'
```
4. Push to branch:
```bash
git push origin feature/YourFeature
```
5. Submit pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This platform is for educational purposes. Use at your own risk. Always perform proper due diligence before lending or borrowing funds.