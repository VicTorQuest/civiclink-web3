# Civiclink

CivicLink is a decentralized Web3 application that provides verified public official contact details using smart contracts. Users access official information directly through their wallet (via MetaMask), and the app leverages the blockchain for secure, immutable data storage. With built-in functionality for user registration and basic messaging, CivicLink ensures transparency and trust in government communication.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Smart Contract Overview](#smart-contract-overview)

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

The project consists of a single Solidity contract that implements the on-chain API for accessing and managing public official contact details. For a comprehensive view of the full project structure and architecture, please refer to [this document](https://docs.google.com/document/d/1X0xwat0RYciPV2QaOmS1iyzy7ZSAxpkFS0PvTsnnoLU/edit?tab=t.0).

---

## Getting Started

### Prerequisites

- **Node.js & NPM**: Ensure [Node.js](https://nodejs.org/) and NPM are installed.
- **Ethereum Development Environment**: Tools like [Hardhat](https://hardhat.org/) are required for compiling and deploying the smart contract.
- **Web3 Wallet**: Use a wallet such as MetaMask or WalletConnect to interact with the contract.
- **Ethers.js**: A JavaScript library for interacting with Ethereum.

### Installation

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/VicTorQuest/civiclink-web3

2. **Install Dependencies**

    ```bash
    npm install --save-dev hardhat
    npm install @nomiclabs/hardhat-ethers ethers


# Smart Contract Overview

The CivicLink smart contract is written in Solidity and provides a fully decentralized API that enables:

- **Official Information Management**  
  Functions to add, retrieve, and search for public officials, along with their verified contact details.

- **On-Chain Messaging**  
  Allows users (identified solely by wallet addresses) to send and retrieve messages with public officials.

- **Data Integrity and Transparency**  
  All data is stored directly on-chain, ensuring immutability and making the system tamper-proof.

User authentication is entirely wallet-based, with each function call using the caller’s wallet address (msg.sender) as the unique identifier.