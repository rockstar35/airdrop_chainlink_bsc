// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/escrow/EscrowUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


contract MyPGUpgradeable is Initializable, OwnableUpgradeable
{
    // Storage
    uint32 public                   contractVersion;
    address payable public          wallet;
    EscrowUpgradeable public        escrow;
    
    // Emitters
    event InitV1R1_Start();
    event InitV1R1_End();

    // Constructor & Version Initializer
    constructor() {}
    function initialize(address payable _wallet) public initializer
    {
        emit InitV1R1_Start();
         __Ownable_init();
        contractVersion     = 100100;   //Just an arbitary version numbering
        wallet              = _wallet;
        escrow              = new EscrowUpgradeable();
        emit InitV1R1_End();
    }

    // ===================================
    // Functions
    
    // !! This function hits error "Caller is not Owner"
    function sendPayment() external payable
    {
        escrow.deposit{value: msg.value}(wallet);
        // ^^ When sendPayment() is executed via TRUFFLE CONSOLE, it will trigger the following exception:
        // truffle(development)> x.sendPayment( {from: accounts[1], value: web3.utils.toWei("1", "ether")} )
        // Uncaught:
        // Error: Returned error: VM Exception while processing transaction: revert Ownable: caller is not the owner -- Reason given: Ownable: caller is not the owner.
    }

    // ---------------------------
    // WORKS OK! All these functions works ok as intended when called with {from: accounts[0] and accounts[1]}
    function withdraw() external onlyOwner
    {escrow.withdraw(wallet);}

    function balance() external view onlyOwner returns (uint256)
    {return escrow.depositsOf(wallet);}

    // TEST: Anyone can call, will return 5.
    function return5() external pure returns (uint16)
    {return 5;}

    // TEST: Only owner can call, return 6.
    function return6() external view onlyOwner returns (uint16) 
    {return 6;}
}