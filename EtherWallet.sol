// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EtherWallet {

    address payable public immutable owner;

    event Log(string funName,address from,uint256 value,bytes data);

    constructor(){
        owner = payable(msg.sender);
    }
    // 它用于接收以太币或通证发送到合约地址的资金
    receive() external payable { 
        emit Log("receive", msg.sender, msg.value, "");
    }


    function withdraw1() external {
        require(msg.sender == owner,"Not owner");
        // 发送 amount 数量的以太币，固定使用 2300 gas，错误时会 revert
        payable(msg.sender).transfer(100);
    }

    function withdraw2() external {
        require(msg.sender == owner, "Not owner");
        // 发送 amount 数量的以太币，固定使用 2300 gas，错误时不会 revert
        bool success = payable(msg.sender).send(200);
        require(success,"Send Failed");
    }


    function withdraw3() external {
        require(msg.sender == owner, "Not owner");
        // 发送 amount 数量的以太币，gas 可以自由设定，返回布尔值表示成功或失败
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Call Failed");
    }


    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}