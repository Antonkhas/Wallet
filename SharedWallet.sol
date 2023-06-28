//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
// Данный контракт предоставляет следующий функционал:
    // Сохранение владельца контракта в переменной _owner. Это происходит в конструкторе.
    // Модификатор onlyOwner(), который проверяет, что инициатор транзакции является также владельцем.
    // Функция renounceOwnership(), которая удаляет владельца из контракта — фактически, после её вызова у контракта больше не будет владельца.
    // Функция transferOwnership() для передачи владения другому адресу.
    // Событие OwnershipTransferred, которое порождается при измении владельца.


contract SharedWallet is Ownable {
    // Cделаем так, чтобы в нашем контракте можно было добавлять других пользователей
    // и устанавливать для них лимит на вывод денежных средств
    mapping(address => uint) public members;

    function isOwner() internal view returns(bool) {
        return owner() == _msgSender();
    }


    modifier ownerOrWithinLimits(uint _amount) {
        require(isOwner() || members[_msgSender()] >= _amount, "You are not allowed to perform this operation!");
        _;
    }

      function addLimit(address _member, uint _limit) public onlyOwner {
        members[_member] = _limit;
    }

    function deduceFromLimit(address _member, uint _amount) internal {
        members[_member] -= _amount;
    }

    function renounceOwnership() override public view onlyOwner {
    revert("Can't renounce!");
    }

}