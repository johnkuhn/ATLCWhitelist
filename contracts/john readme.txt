I used whitelisted-tokensale-master.zip as the base for this project.

This project is a set of contracts allowing for whitelisting buyers. Whitelisting can also be disabled and a multiplier/divisor can be set for establishing price per ETH/DAI of our ATLC token and selling it directly to buyers. ETH/DAI during the Buy operation can either be sent to an external wallet or stored within the wallet for manual withdrawal later by an admin. Sale can be paused and cooldown period set for buyers preventing them from buying again after so many minutes.

Testing can be done using Remix VM or MetaMask.

*********************************************************************************************************

Recap:
1. ATLC tokens will need sent to the address of the TokenSale contract. Anything unsold can be transferred back out to admin executing the withdraw functions.
2. BuyTokens functions will take ETH/DAI and hold it in the address of the TokenSale contract or can be sent to an external wallet. The contract will then transfer appropriate amount of ATLC tokens out to the buyer based on the multiplier/divisor configured amounts.
3. Withdraw functions will send the DAI being held in the TokenSale contract address to the caller. In this case any Admin can be transferred the xDAI tokens. Same with Withdraw of ALTC tokens. All or portion can be sent to admin caller's wallet.


Recap again:
1. ATLC tokens will need sent to the address of the TokenSale contract.
2. BuyTokens6 (now called buyTokensHoldInContract) function call will take xDAI and hold it in the address of the TokenSale contract and it will send appropriate amount of ATLC tokens out to the buyer.
3. Withdraw and WithdrawAll functions will send the total xDAI being held in the TokenSale contract address to the caller. In this case any Admin can be transferred the xDAI tokens. In my Withdraw, I sent it to d537 whom I made an admin of the contract. Coincidentally, this same d537 account is an owner as well.
New BuyTokens7 (now called  buyTokensSendToWallet)  function call will take xDAI and immediately transfer it to the wallet that we've specified INSTEAD of holding it in the TokenSale contract directly. Then, it will send appropriate amount of ATLC tokens out to the buyer.

LESSEN LEARNED
Ether and Dai are the same things.  They are what is sent to a contract by default using the top remix buttons and will end up being executed by the empty receive functions if now other payable functions are in the contract.
Specify values at the top of remix such as 1 Ether (selection from dropdown) and click one of my buyToken buttons to send that amount of Ether in as spend.  Then, transfer our custom token values proportionally back out with the math.
If you use the Transact button instead of our own function specific button like buyToken, I think it will call the default receive() function and the contract will just receive the Ether and nothing about the contents of our own payable function would get executed in order to transfer out our own token values to the buyer.

I have been able to test everything in Remix VM same as in Metamask with the exception of the WhitelistRegistry which I didn't try deploying to Remix VM and ended up setting whitelist to false.

*********************************************************************************************************

SUMMARY:
1. Deploy WhitelistRegistry (this is where whitelisted addresses will go)
2. Initialize, AddAdmins, AddManager, addCustomerToWhitelist for all customers.
3. Note the address of this deployed contract.
4. Deploy TokenSale (where sales will be performed). Customers send us ETH/DAI and we send the proportional amount of ATLC tokens in return.
5. Initialize, AddAdmins, SetWallet.
6. Fund the TokenSale contract with ATLC tokens
7. Can pause, adjust multiplier/divisor as necessary for pricing, and set cooldown period for example to 60 minutes to force users to wait 1 hour in between Buy operations.
8. Withdraw can be done by any admin and will go to their own msg.sender calling address wallet. Specific amounts or ALL ETH and/or ALL ATLC withdrawals are supported by separate functions.
9. There are 2 separate Buy functions. 1 will auto-send the customer's ETH/DAI to an external wallet. The other will keep their ETH/DAI in the contract itself which will need extracted later manually by the Withdraw functions.

*********************************************************************************************************

Typical testing scenario is as follows:

Deploy WhitelistRegistry contract as the owner.  Get the address of it. This is where all our whitelisted customers will be stored.
Address: xxx
addAdmin: 0x643A87055213c3ce6d0BE9B1762A732e9E059536 (set the contract owner's account address as the admin)
addCustomerToWhitelist: 0x643A87055213c3ce6d0BE9B1762A732e9E059536 
addManager: 0x643A87055213c3ce6d0BE9B1762A732e9E059536   (set the contract owner's account address as the admin)
Initialize (pass in Owner):  0x832F90cf5374DC89D7f8d2d2ECb94337f54Dd537 (SUCCESS)

NOTE: If I switch my metamask browser tab account, it WILL automatically switch the Account that is selected in remix.

*********************************************************************************************************

Deployed MyNewMinter: (0xd9145CCE52D386f254917e481eB44e9943F39138)
Deploy TokenSale: (0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d)

Initialize: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xd9145CCE52D386f254917e481eB44e9943F39138, 0xdD870fA1b7C4700F2BD7f44238821C26f7392148, false, 20, 1   (note, I grabbed the last account in the dropdown as the whitelist contract but passed in false so it won't get used anyway)
AddAdmin: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4(added the TokenSale contract owner as the admin)
SetWallet: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2(2nd Account in dropdown)  TODO: I can probably remove this because I'm not successfully able to send the Ether to an outside wallet when Buys are made.

I minted 5000 tokens from MyNewMinter over to the TokenSale contract: 0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d, 5000000000000000000000

getContractBalance: 5000000000000000000000
getContractBalanceWholeTokens: 5000  

buyTokens as 3rd account in dropdown: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
I selected 1 Ether at the top of Remix.
Clicked buyTokens6.

