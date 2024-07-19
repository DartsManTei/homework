// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Bank {
    // 状态变量
    // immutable 修饰的变量是在部署的时候确定变量的值, 它在构造函数中赋值一次之后,
    // 就不在改变, 这是一个运行时赋值, 就可以解除之前 constant 不支持使用运行时状态赋值的限制.
    address public immutable owner;
    // 事件
    event Deposit(address _ads, uint256 amount);
    event Withdraw(uint256 amount);

    // receive 函数是 Solidity 中的一种特殊函数，它主要被用来接收 Ether 转账
    receive() external payable { 
        // 要触发事件，可以使用emit关键字后跟事件名称，并传递相应的参数。
        emit Deposit(msg.sender, msg.value);
    }

    // 构造函数
    constructor() payable {
        owner = msg.sender;
    }


    // 方法
    function withdraw() external {
        require(msg.sender == owner, "Not Owner");
        emit Withdraw(address(this).balance);
        // 自我销毁，已废弃
        // selfdestruct(payable(msg.sender));
    }
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}