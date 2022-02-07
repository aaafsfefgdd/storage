//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Storage {

    struct Person {
        string  name;
        uint256 age;
    }
    
    bytes32 public keccakStr;
    Person[] public person;
    mapping(string => uint256) public accountBalance;

    function _addPerson (string calldata _name, uint256 _age) private {
        Person memory nian = Person(_name, _age);
        person.push(nian);
    }

    function addPerson(string calldata _name, uint256 _age) public {
        _addPerson(_name, _age);
    }

    function keccakTest() public {
        keccakStr = keccak256("aaaaaaaaaaaa");
    }

    function addBalance(string calldata _str, uint256 _balance) public {
        accountBalance[_str] = _balance;
    }

}

