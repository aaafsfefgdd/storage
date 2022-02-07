//SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

contract Ballot {
    // Voter结构用来表示一个选民
    struct Voter {
        uint    weight;
        bool    voted;
        address delegate;
        uint    vote;
    }

    // Proposal结构用来表示一个提案
    struct Proposal {
        string name;
        uint    voteCount;
    }

    // 选举委员会主席
    address public chairperson;

    // 存储了所有的选民
    mapping(address => Voter) public voters;

    // 所有的提案
    Proposal[] public proposals;

    // 这是合约构造函数，初始化所有的提案
    constructor(string[] memory proposalNames) {
        // 先定义选举委员会主席
        chairperson = msg.sender;

        // 创建提案，初始票数为0票.
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({name: proposalNames[i], voteCount: 0}));
        }
    }

    // 向选民发放选票，每个选民有一个投票权
    function giveRightToVote(address voter) public {
        // 只有主席有权利发放选票
        require(msg.sender == chairperson, "Only chairperson can give right to vote.");

        // 该选民已经投过票了，不能重复发放选票
        require(voters[voter].voted == false, "The voter already voted.");

        require(voters[voter].weight == 0);
        voters[voter].weight = 1;   // 发放选票
    }

    // 委托他人投票
    function delegate(address to) public {
        Voter storage sender = voters[msg.sender];
        require(sender.voted == false, "You already voted.");
        require(to != msg.sender, "Self-delegation is disabllowed.");

        while(voters[to].delegate != address(0)) {
                to = voters[to].delegate;
                require(to != msg.sender, "Found loop in delegation.");
        }

        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            proposals[delegate_.vote].voteCount += sender.weight;
        }
        else {
            delegate_.weight += sender.weight;
        }
    }

    // 投票
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.voted == false, "Already voted.");
        sender.voted = true;  
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    // 计算最终票数
    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    function winnerName() public view returns (string memory winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }


}
