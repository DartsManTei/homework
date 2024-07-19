// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


/**
WETH 是包装 ETH 主币，作为 ERC20 的合约。 标准的 ERC20 合约包括如下几个

3 个查询
balanceOf: 查询指定地址的 Token 数量
allowance: 查询指定地址对另外一个地址的剩余授权额度
totalSupply: 查询当前合约的 Token 总量
2 个交易
transfer: 从当前调用者地址发送指定数量的 Token 到指定地址。
这是一个写入方法，所以还会抛出一个 Transfer 事件。
transferFrom: 当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token 拿到它自己的合约中。
2 个事件
Transfer
Approval
1 个授权
approve: 授权指定地址可以操作调用者的最大 Token 数量。
*/
contract WETH {

    string public name = "Wrapped Ether";
    string public symbol = "WETH";

    uint8 public decimals = 18;
    // 通过使用indexed修饰符，可以为事件参数创建索引，以提高事件的可搜索性和可过滤性。
    event Approval(address indexed src, address indexed delegateAds, uint256 amount);
    event Transfer(address indexed src, address indexed toAds, uint256 amount);
    event Deposit(address indexed toAds, uint256 amount);
    event Withdraw(address indexed src, uint256 amount);
    // 查询指定地址的 Token 数量
    mapping(address => uint256) public balanceOf;
    // 查询指定地址对另外一个地址的剩余授权额度
    mapping(address => mapping(address => uint256)) public allowance;


    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount);
        balanceOf[msg.sender] -= amount;
        // payable(owner)将合约所有者的地址转换为一个可支付地址（即允许发送以太币的地址）。
        // .transfer(_amount)从合约中提取指定数量的以太币，并发送到合约所有者的地址。
        payable(msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    // 额度查询
    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    function approve(address delegateAds, uint256 amount) public returns (bool) {
        allowance[msg.sender][delegateAds] = amount;
        emit Approval(msg.sender, delegateAds, amount);
        return true;
    }

    function transferFrom(
        address src,
        address toAds,
        uint256 amount
    ) public returns (bool) {
        require(balanceOf[src] >= amount);
        if (src != msg.sender) {
            require(allowance[src][msg.sender] >= amount);
            allowance[src][msg.sender] -= amount;
        }
        balanceOf[src] -= amount;
        balanceOf[toAds] += amount;
        emit Transfer(src, toAds, amount);
        return true;
    }


    fallback() external payable {
        deposit();
    }
    receive() external payable {
        deposit();
    }
}