// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFlatDirectoryFactory {
    function create() external returns (address);
}

interface IFlatDirectory {
    function write(bytes memory name, bytes memory data) external payable;

    function read(bytes memory name) external view returns (bytes memory, bool);
}

library TextLib {
    function uintToBytes(uint v) internal pure returns (bytes memory) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = bytes1(uint8(48 + remainder));
        }
        bytes memory s = new bytes(i + 1);
        for (uint j = 0; j <= i; j++) {
            s[j] = reversed[i - j];
        }
        return s;
    }

    function uintToString(uint v) internal pure returns (string memory) {
        return string(uintToBytes(v));
    }

    function addressToBytes(address a) internal pure returns (bytes memory b) {
        assembly {
            let m := mload(0x40)
            a := and(a, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            mstore(
            add(m, 20),
            xor(0x140000000000000000000000000000000000000000, a)
            )
            mstore(0x40, add(m, 52))
            b := m
        }
    }
}

contract SimpleMessageBoard {

    uint256 public messageCount;
    IFlatDirectory public fileFD;

    constructor(IFlatDirectoryFactory _factory) {
        address fd = _factory.create();
        fileFD = IFlatDirectory(fd);
    }

    function writeMessage(string memory content) public payable {
        require(bytes(content).length != 0, "Invalid content");
        _writeMessage(messageCount, bytes(content));
        _writeOwner(messageCount, msg.sender);
        _writeTimestamp(messageCount, block.timestamp);
        messageCount++;
    }

    function _writeMessage(uint256 id, bytes memory content) internal {
        fileFD.write(abi.encodePacked(string(TextLib.uintToString(id)), "message"), content);
    }

    function _writeOwner(uint256 id, address owner) internal {
        fileFD.write(abi.encodePacked(string(TextLib.uintToString(id)), "owner"), TextLib.addressToBytes(owner));
    }

    function _writeTimestamp(uint256 id, uint256 timestamp) internal {
        fileFD.write(abi.encodePacked(string(TextLib.uintToString(id)), "timestamp"), TextLib.uintToBytes(timestamp));
    }

    function getMessages()
        public
        view
        returns (
            bytes[] memory contents,
            bytes[] memory users,
            bytes[] memory timestamps
        )
    {
        contents = new bytes[](messageCount);
        users = new bytes[](messageCount);
        timestamps = new bytes[](messageCount);
        for (uint256 i = 0; i < messageCount; i++) {
            contents[i] = _getComment(i);
            users[i] = _getOwner(i);
            timestamps[i] = _getTimestamp(i);
        }
    }

    function _getComment(uint256 id) internal view returns (bytes memory content) {
        (content, ) = fileFD.read(abi.encodePacked(string(TextLib.uintToString(id)), "message"));
    }

    function _getOwner(uint256 id) internal view returns (bytes memory content) {
        (content, ) = fileFD.read(abi.encodePacked(string(TextLib.uintToString(id)), "owner"));
    }

    function _getTimestamp(uint256 id) internal view returns (bytes memory content) {
        (content, ) = fileFD.read(abi.encodePacked(string(TextLib.uintToString(id)), "timestamp"));
    }
}
