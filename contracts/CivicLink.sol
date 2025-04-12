// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CivicLink is Ownable {

    constructor() Ownable(msg.sender) {

    }

    struct Official {
        uint256 id;
        string name;
        string role;            // e.g., "Minister of Finance"
        string about;           // About the official
        string contactEmail;    // Verified contact email address
        string officeLine;      // Verified office line
        address walletAddress;    // Verified address of the official
        string imageUrl;        // Photo of verified government official
        uint256 verifiedAt;     // Verification date
        string structureName;   // Name of associated government structure
    }

    enum MessageStatus { Sent, Read }

    struct Message {
        uint256 id;
        address senderAddress;  // Sender's(possibly user) address
        uint256 receiverId;     // Official's ID
        string content;         // Message content
        uint256 timestamp;      // Timestamp when the message was sent
        MessageStatus status;   // e.g., "sent", "read"
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

    mapping(uint256 => uint256[]) private officialMessageIds;


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
        if (strBytes.length == 0) return false; 
        bytes memory substrBytes = bytes(substr);
        if (substrBytes.length == 0) return false; 
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

    /*
     * @notice Adds a new official's verified contact details.
     * @dev For MVP purposes, this function is public. In production, access control should restrict it to authorized parties.
     * @param _name The official's full name.
     * @param _role The official's role/title.
     * @param _contactEmail The verified contact email.
     * @param _officeLine The verified officeLine number.
     * @param _structureName The associated government structure.
     * @return success True if the official is added successfully.
     */ 


    function addOfficial(Official calldata _params) external onlyOwner returns (bool) {
        officialCount++;
        officials[officialCount] = Official({
            id: officialCount,
            name: _params.name,
            role: _params.role,
            about: _params.about,
            contactEmail: _params.contactEmail,
            officeLine: _params.officeLine,
            walletAddress: _params.walletAddress,
            imageUrl: _params.imageUrl,
            verifiedAt: block.timestamp,
            structureName: _params.structureName
        });
        officialIds.push(officialCount);
        emit OfficialAdded(officialCount, _params.name);
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
    function searchOfficials(string calldata _keyword) external view returns (Official[] memory) {
        Official[] memory tempMatches = new Official[](officialIds.length);
        uint256 matchCount = 0;

        for (uint256 i = 0; i < officialIds.length; i++) {
            Official memory off = officials[officialIds[i]];
            if (_contains(off.name, _keyword) ||
                _contains(off.role, _keyword) ||
                _contains(off.structureName, _keyword)) {
                tempMatches[matchCount] = off;
                matchCount++;
            }
        }

        // Copy matched results into correctly-sized array
        Official[] memory results = new Official[](matchCount);
        for (uint256 i = 0; i < matchCount; i++) {
            results[i] = tempMatches[i];
        }

        return results;
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
            status: MessageStatus.Sent
        });
        userMessageIds[msg.sender].push(messageCount);
        officialMessageIds[_receiverId].push(messageCount);
        emit MessageSent(messageCount, msg.sender, _receiverId);
        return true;
    }


    // Add new function:
    function getOfficialMessages(uint256 _officialId) external view returns (Message[] memory) {
        require(_officialId > 0 && _officialId <= officialCount, "Invalid official ID");
        uint256[] memory msgIds = officialMessageIds[_officialId];
        Message[] memory received = new Message[](msgIds.length);
        for (uint256 i = 0; i < msgIds.length; i++) {
            received[i] = messages[msgIds[i]];
        }
        return received;
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
