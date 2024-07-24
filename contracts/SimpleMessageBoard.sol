// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleMessageBoard {

    struct Message {
        address author;
        uint256 timestamp;
        string content;
    }

    Message[] public messages;

    function writeMessage(string memory content) public payable {
        require(bytes(content).length != 0, "Invalid content");
        messages.push(Message(msg.sender, block.timestamp, content));
    }

    function getMessages()
        public
        view
        returns (
            address[] memory authors,
            uint256[] memory timestamps,
            string[] memory contents
        )
    {
        uint256 messageCount = messages.length;
        authors = new address[](messageCount);
        timestamps = new uint256[](messageCount);
        contents = new string[](messageCount);
        for (uint256 i = 0; i < messageCount; i++) {
            authors[i] = messages[i].author;
            timestamps[i] = messages[i].timestamp;
            contents[i] = messages[i].content;
        }
    }
}
