// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/LoyaltyProgramFactory.sol";

contract LoyaltyProgramFactoryScript is Script {

}

/*
forge create \
  --rpc-url https://rpc-nebulas-testnet.uniultra.xyz \
  --private-key 0339837ebb904e2b887cef67e9e9d99e9a9ab36f9c309a7a6a5be927481036d8 \
  src/LoyaltyProgramFactory.sol:LoyaltyProgramFactory \
  --broadcast

*/

//verify
/*
forge verify-contract \
  --chain-id 2484 \
  --verifier-url https://testnet.u2uscan.xyz/api \
  --etherscan-api-key [PRIVATE_KEY] \
  0x528991DD861Ad6fa964D3112a73542095AAEF950 \
  src/LoyaltyProgramFactory.sol:LoyaltyProgramFactory
*/
