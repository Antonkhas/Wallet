//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "./SharedWallet.sol";

contract Wallet is SharedWallet {
    event MoneyWithdrawn(address indexed _to, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    // функция для вывода указанной суммы денег на свой адрес (то есть на адрес инициатора транзакции):
    function withdrawMoney(uint _amount) public ownerOrWithinLimits(_amount){
        require(_amount <= address(this).balance, "Not enough funds to withdraw!");

        if(!isOwner()) { 
            deduceFromLimit(_msgSender(), _amount); 
        }

        address payable _to = payable(_msgSender()); // вместо msg.sender мы можем использовать функцию _msgSender(), которая доступна в OpenZeppelin
        _to.transfer(_amount);

        emit MoneyWithdrawn(_to, _amount);
    }

    // вспомогательные функции, позволяющие зачислять деньги на счёт контракта и проверять баланс
    function sendToContract(address _to) public payable {
        address payable to = payable(_to);
        to.transfer(msg.value);

        emit MoneyReceived(_msgSender(), msg.value);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    fallback() external payable { }

    receive() external payable { emit MoneyReceived(_msgSender(), msg.value);  }

}