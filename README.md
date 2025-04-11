# Civiclink

CivicLink is a decentralized Web3 application that provides verified public official contact details using smart contracts. Users access official information directly through their wallet (via MetaMask), and the app leverages the blockchain for secure, immutable data storage. With built-in functionality for user registration and basic messaging, CivicLink ensures transparency and trust in government communication.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Compilation and Deployment](#compilation-and-deployment)
- [Usage](#usage)
  - [Interacting with the Contract](#interacting-with-the-contract)
  - [Frontend Integration Example](#frontend-integration-example)
- [Smart Contract Overview](#smart-contract-overview)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Decentralized Contact Information:**  
  Retrieve vetted contact details (name, role, contact email, phone, and government structure) for public officials stored directly on-chain.
  
- **Wallet-Based Authentication:**  
  Users are identified solely by their wallet address, eliminating the need for traditional credentials.

- **On-Chain Messaging:**  
  Send messages directly to public officials through the smart contract, with all interactions handled on-chain.

- **Keyword Search:**  
  Search for officials by matching keywords against their name, role, or associated government structure.

- **Fully Decentralized API:**  
  All functionality is exposed via the CivicLink smart contract and accessed through Web3 libraries like Ethers.js, ensuring transparency and security.

---

## Project Structure

civiclink-web3/
 ├── contracts/
    └── CivicLink.sol  # Solidity smart contract(s); contains the main on-chain logic.
 ├── frontend/           # Contains the client-side code for the web application.
    └── (HTML, JavaScript, CSS, etc.)
 ├── ignition/
    └── modules/   # Contains Hardhat Ignition modules.
 ├── scripts/         # Deployment scripts, test scripts or any utility scripts.
    └── (various JS scripts)
 ├── hardhat.config.js  # Hardhat configuration file – sets up network, compiler, plugins, etc.
   ├── package-lock.json   # Auto-generated file that locks the versions of package dependencies.
     └── package.json    # Lists project dependencies, scripts, and metadata.


The project consists of a single Solidity contract that implements the on-chain API for accessing and managing public official contact details.

---

## Getting Started

### Prerequisites

- **Node.js & NPM**: Ensure [Node.js](https://nodejs.org/) and NPM are installed.
- **Ethereum Development Environment**: Tools like [Hardhat](https://hardhat.org/) are required for compiling and deploying the smart contract.
- **Web3 Wallet**: Use a wallet such as MetaMask or WalletConnect to interact with the contract.
- **Ethers.js**: A JavaScript library for interacting with Ethereum.
