// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract CivicLink {

    // struct definitions
    struct User {
        uint id;
        address walletAddress;
        uint256 createdAt;
    }

    struct Official {
        uint256 id;
        string name;
        string role;           // e.g., "Minister of Finance"
        string contactEmail;   // Verified contact email address
        string officeLine;     // Verified office line
        string structureName;  // Name of associated government structure
    }

    struct Message {
        uint256 id;
        uint256 senderId;     // Sender's(possibly user) id
        uint256 receiverId;   // Official's ID
        string content;
        uint256 timestamp;
        string status;        // e.g., "sent", "read"
    }

    // --- State Variables ---
    uint256 public userCount;
    uint256 public officialCount;
    uint256 public messageCount;

    // mapping:  provides a fast, constant-time lookup so that when a user interacts with the contract (using their wallet address as msg.sender)

    // Mapping for users: wallet address to user ID
    mapping(address => uint256) public userIds;
    mapping(uint256 => User) public users;


    // Mapping for officials
    mapping(uint256 => Official) public officials;
    uint256[] public officialIds;


    // Mapping for messages: sender's wallet address to list of message IDs
    mapping(address => uint256[]) public userMessageIds;
    mapping(uint256 => Message) public messages;


    // --- Events ---
    event UserRegistered(uint256 indexed userId, address indexed userAddress);
    event UserUpdated(uint256 indexed userId);
    event OfficialAdded(uint256 indexed officialId, string name);
    event MessageSent(uint256 indexed messageId, uint256 senderId, uint256 receiverId);


}
