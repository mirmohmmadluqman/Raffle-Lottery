// SPDX-Liense-Identifier: Check License in Repository
pragma solidity ^0.8.19;



// import {VRFV2PlusClient} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
// import {IVRFCoordinatorV2Plus} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/vrf/dev/interfaces/IVRFCoordinatorV2Plus.sol";


/**
    *@title Raffle-Lottery Smart Contract
    *@author Mir Mohmmad Luqman
    *@notice This contract is created for sample raffle lottery.
    *@dev Implements Chainlink VRFv2.5
**/



contract Raffle {

    // Errors --------------------------------------------------------------------------------------------------
    error NotEnoughEthEntered();





    // events --------------------------------------------------------------------------------------------------
    event RaffleEntered(address indexed player);





    // State Variables -------------------------------------------------------------------------------------------
    uint256 public immutable i_entranceFee;
    address payable[] private s_players;
    uint256 private immutable i_interval; 
    uint256 private s_lastTimeStamp;





    // Modifiers --------------------------------------------------------------------------------------------------
    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp; // s_lastTimeStamp = now, Current Block Time
    }





    // Functions -------------------------------------------------------------------------------------------------
    function enterRaffle() external payable { // Logic to enter the raffle
        // require(msg.value >= i_entranceFee, "Not enough ETH entered!");
        // Don' use ^, it is not Gas Efficient, because we are storing a string here ^\
        // require(msg.value >= i_entranceFee, NotEnoughEthEntered());
        // or use ^ if compiler version is => 0.8.26v 
        if (msg.value >= i_entranceFee) {
            revert NotEnoughEthEntered(); //⛔
        }
        s_players.push(payable(msg.sender)); // Add the player to the players array
        emit RaffleEntered(msg.sender); // Emit the event, that you(msg.sender) had entered the raffle as player

    }

    // 1. Get a random number 
    // 2. Use - ^ to pick a winner 
    // Be automatically call-able (called) 
    function pickWinner() external {
        // Check to see if the raffle is over, time is enough, or not
        if((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert(); //⛔
        }

        requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    // Set nativePayment to true to pay for VRF requests with Sepolia ETH instead of LINK
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
    } 




    // Getter Functions -----------------------------------------------------------------------------------------  
    function getEntranceFee() external view returns(uint256) {
        return i_entranceFee;
    }

}




// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions