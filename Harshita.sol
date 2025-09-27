// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title GreetingContract
 * @dev A smart contract that allows users to store and retrieve personalized greetings
 * @author Your Name
 */
contract GreetingContract {
    // Mapping to store greetings for each address
    mapping(address => string) private greetings;
    
    // Mapping to track if an address has set a greeting
    mapping(address => bool) private hasGreeting;
    
    // Array to keep track of all addresses that have set greetings
    address[] private greetingUsers;
    
    // Event emitted when a greeting is set
    event GreetingSet(address indexed user, string greeting);
    
    // Event emitted when a greeting is updated
    event GreetingUpdated(address indexed user, string oldGreeting, string newGreeting);
    
    /**
     * @dev Set a personalized greeting for the calling address
     * @param _greeting The greeting message to store
     */
    function setGreeting(string memory _greeting) external {
        require(bytes(_greeting).length > 0, "Greeting cannot be empty");
        require(bytes(_greeting).length <= 200, "Greeting too long (max 200 characters)");
        
        string memory oldGreeting = greetings[msg.sender];
        bool hadGreeting = hasGreeting[msg.sender];
        
        greetings[msg.sender] = _greeting;
        
        if (!hadGreeting) {
            hasGreeting[msg.sender] = true;
            greetingUsers.push(msg.sender);
            emit GreetingSet(msg.sender, _greeting);
        } else {
            emit GreetingUpdated(msg.sender, oldGreeting, _greeting);
        }
    }
    
    /**
     * @dev Get the greeting for a specific address
     * @param _user The address to get the greeting for
     * @return The greeting message for the specified address
     */
    function getGreeting(address _user) external view returns (string memory) {
        require(hasGreeting[_user], "No greeting set for this address");
        return greetings[_user];
    }
    
    /**
     * @dev Get the greeting for the calling address
     * @return The greeting message for the caller
     */
    function getMyGreeting() external view returns (string memory) {
        require(hasGreeting[msg.sender], "You haven't set a greeting yet");
        return greetings[msg.sender];
    }
    
    /**
     * @dev Check if an address has set a greeting
     * @param _user The address to check
     * @return True if the address has set a greeting, false otherwise
     */
    function hasUserSetGreeting(address _user) external view returns (bool) {
        return hasGreeting[_user];
    }
    
    /**
     * @dev Get the total number of users who have set greetings
     * @return The count of users with greetings
     */
    function getTotalGreetingUsers() external view returns (uint256) {
        return greetingUsers.length;
    }
    
    /**
     * @dev Get all addresses that have set greetings
     * @return Array of addresses that have set greetings
     */
    function getAllGreetingUsers() external view returns (address[] memory) {
        return greetingUsers;
    }
}

