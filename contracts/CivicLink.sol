// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract CivicLink {

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
        address senderAddress;     // Sender's(possibly user) id
        uint256 receiverId;   // Official's ID
        string content;       // Message content
        uint256 timestamp;    // Timestamp when the message was sent
        string status;        // e.g., "sent", "read"
    }

    // --- State Variables ---
    uint256 public officialCount;
    uint256 public messageCount;


     // Mapping for officials: official ID => Official struct
    mapping(uint256 => Official) public officials;
    uint256[] public officialIds; // List of all official IDs


    // Mapping for messages: sender wallet => list of message IDs
    mapping(address => uint256[]) private userMessageIds;

    // Mapping for message ID => Message struct
    mapping(uint256 => Message) public messages;


    // --- Events ---
    event OfficialAdded(uint256 indexed officialId, string name);
    event MessageSent(uint256 indexed messageId, address indexed sender, uint256 receiverId);


    // --- Internal Helper Function ---
    
    /**
     * @dev Internal helper function to determine if `substr` is present in `str`.
     * @param str The string to search.
     * @param substr The substring to look for.
     * @return True if `substr` is found in `str`, otherwise false.
     */
    function _contains(string memory str, string memory substr) internal pure returns (bool) {
        bytes memory strBytes = bytes(str);
        bytes memory substrBytes = bytes(substr);
        if (substrBytes.length > strBytes.length) return false;
        for (uint256 i = 0; i <= strBytes.length - substrBytes.length; i++) {
            bool found = true;
            for (uint256 j = 0; j < substrBytes.length; j++) {
                if (strBytes[i + j] != substrBytes[j]) {
                    found = false;
                    break;
                }
            }
            if (found) return true;
        }
        return false;
    }



    // --- Official Information Functions ---

    /**
     * @notice Adds a new official's verified contact details.
     * @dev For MVP purposes, this function is public. In production, access control should restrict it to authorized parties.
     * @param _name The official's full name.
     * @param _role The official's role/title.
     * @param _contactEmail The verified contact email.
     * @param _officeLine The verified officeLine number.
     * @param _structureName The associated government structure.
     * @return success True if the official is added successfully.
     */ 


    function addOfficial(string calldata _name, string calldata _role, string calldata _contactEmail, string calldata _officeLine, string calldata _structureName) external returns (bool success) {
        officialCount++;
        officials[officialCount] = Official({
            id: officialCount,
            name: _name,
            role: _role,
            contactEmail: _contactEmail,
            officeLine: _officeLine,
            structureName: _structureName
        });
        officialIds.push(officialCount);
        emit OfficialAdded(officialCount, _name);
        return true;
    }

    /**
     * @notice Retrieves all vetted public officials.
     * @return allOfficials An array of Official structs.
     */
    function getOfficials() external view returns (Official[] memory allOfficials) {
        allOfficials = new Official[](officialIds.length);
        for (uint256 i = 0; i < officialIds.length; i++) {
            allOfficials[i] = officials[officialIds[i]];
        }
    }


    /**
     * @notice Retrieves detailed information for a specific official.
     * @param _officialId The unique identifier of the official.
     * @return The Official struct corresponding to the provided _officialId.
     */
    function getOfficialDetails(uint256 _officialId) external view returns (Official memory) {
        require(_officialId > 0 && _officialId <= officialCount, "Invalid official ID");
        return officials[_officialId];
    }


    /**
     * @notice Searches for officials by a given keyword.
     * @param _keyword The search keyword; matches against the official's name, role, or structure name.
     * @return results An array of Official structs matching the search criteria.
     */
    function searchOfficials(string calldata _keyword) external view returns (Official[] memory results) {
        uint256 matchCount = 0;
        for (uint256 i = 0; i < officialIds.length; i++) {
            Official memory off = officials[officialIds[i]];
            if (_contains(off.name, _keyword) ||
                _contains(off.role, _keyword) ||
                _contains(off.structureName, _keyword)) {
                matchCount++;
            }
        }
        results = new Official[](matchCount);
        uint256 j = 0;
        for (uint256 i = 0; i < officialIds.length; i++) {
            Official memory off = officials[officialIds[i]];
            if (_contains(off.name, _keyword) ||
                _contains(off.role, _keyword) ||
                _contains(off.structureName, _keyword)) {
                results[j] = off;
                j++;
            }
        }
    }


    /**
     * @notice Sends a message from the caller to an official.
     * @param _receiverId The ID of the official who will receive the message.
     * @param _content The message content.
     * @return success True if the message is successfully sent.
     */
    function sendMessage(uint256 _receiverId, string calldata _content) external returns (bool success) {
        require(_receiverId > 0 && _receiverId <= officialCount, "Invalid official ID");

        messageCount++;
        messages[messageCount] = Message({
            id: messageCount,
            senderAddress: msg.sender,
            receiverId: _receiverId,
            content: _content,
            timestamp: block.timestamp,
            status: "sent"
        });
        userMessageIds[msg.sender].push(messageCount);
        emit MessageSent(messageCount, msg.sender, _receiverId);
        return true;
    }

    /**
     * @notice Retrieves the message history for the caller.
     * @return history An array of Message structs representing the caller's sent messages.
     */
    function getMessageHistory() external view returns (Message[] memory history) {
        uint256[] memory msgIds = userMessageIds[msg.sender];
        history = new Message[](msgIds.length);
        for (uint256 i = 0; i < msgIds.length; i++) {
            history[i] = messages[msgIds[i]];
        }
    }

}
