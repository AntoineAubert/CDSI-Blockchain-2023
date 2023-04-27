// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Coin
 * @dev Mint and send Coins
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Coin {

    // The keyword "public" makes those variables
    // readable from outside.
    address public minter;
    mapping (address => uint) public balances;

    // Events allow light clients to react on
    // changes efficiently.
    event Sent(address from, address to, uint amount);

    // This is the constructor whose code is
    // run only when the contract is created.
    constructor() {
        minter = msg.sender;
    }

    /**
     * @dev Mint Coins for the Minter
     * @param receiver address of the Minter
     * @param amount the amout to be mint
     */
    function mint(address receiver, uint amount) public  {
        if (msg.sender != minter) return;
        balances[receiver] += amount;
    }

    /**
     * @dev Send Coins between Adresses
     * @param receiver address of the receiver
     * @param amount the amout to be sent to the receiver
     */
    function send(address receiver, uint amount) public {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
