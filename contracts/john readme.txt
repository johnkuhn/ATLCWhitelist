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

Description of the 3 contract files that are attached:
TokenSale.sol - this will be the main contract we use for selling our tokens to buyer through a dApp on our website and using MetaMask.
WhitelistRegistry.sol - this is a separate contract wherein we can load whitelisted addresses.  There is a boolean flag in TokenSale called "whitelistEnabled" that instructs the buyTokens operation in TokenSale on whether or not it should call over to this WhitelistRegistry contract to validate if the buyer is in the whitelist. The reason we did this was because after our whitelist sale is over, we may use the TokenSale in an ongoing basis to sell our tokens.
MyNewMinter.sol - just a simple ERC-20 implementation to allow us to quickly mint new tokens over to TokenSale for testing within the same workspace.

SUMMARY of Execution Steps:
1. Deploy WhitelistRegistry (this is where whitelisted addresses will go). We will write a small program to add all our whitelisted customer addresses to this contract by calling addCustomerToWhitelist function as many times as needed until all addresses are loaded for the whitesale.
2. Functions to call to initially configure this contract:  Initialize, AddAdmins, AddManager, addCustomerToWhitelist for all customers. I typically just add my contract owner as the Admin and as a Manager for my testing purposes.
3. Note the address of this deployed contract.
4. Deploy TokenSale (where sales will be performed). Customers send us ETH/DAI and we send the proportional amount of ATLC tokens in return. We will have a dApp created on our website to allow the customers to buy tokens from this contract by using MetaMask.
5. Functions to call to initially configure this contract:  Initialize, AddAdmins, SetWallet, setSendToWalletEnabled, setWhitelistEnabled (optional). I typically just add my contract owner as the Admin and as a Manager for my testing purposes.
6. Fund the TokenSale contract with our tokens.  I used the MyNewMinter.sol which is just an ERC-20 implementation in this project to assist with spinning up some test tokens and minting them over to the TokenSale contract.
7. In TokenSale , we can pause, adjust multiplier/divisor as necessary for pricing, and set cooldown period for example to 3 minutes to force users to wait 3 minutes between Buy operations. We can also set the maxBuyAmountPerSessionInDAI variable to enforce the maximum amount of our token that can be purchased for each session before having to wait for the cooldown period to finish.
8. In TokenSale, Withdraw() can be done by any admin and will go to their own msg.sender calling address wallet. Specific amounts or ALL ETH and/or ALL our tokens withdrawals are supported by separate functions.
9. There is a buyTokens() function which will be called from our dApp on our website using MetaMask. Based on the boolean flag called "useWallet", it will either keep the ETH/DAI in the contract or will transfer it automatically to our outside wallt. Any ETH/DAI stored in the contract can manually be extracted to an Admin by the Withdraw functions.



*********************************************************************************************************

Typical testing scenario is as follows:

Deploy WhitelistRegistry contract as the owner.  Get the address of it. This is where all our whitelisted customers will be stored.
Address: xxx
Initialize (pass in Owner):  0x832F90cf5374DC89D7f8d2d2ECb94337f54Dd537 (SUCCESS)
addAdmin: 0x832F90cf5374DC89D7f8d2d2ECb94337f54Dd537 (set the contract owner's account address as the admin)
addManager: 0x832F90cf5374DC89D7f8d2d2ECb94337f54Dd537   (set the contract owner's account address as the admin)
addCustomerToWhitelist: 0x643A87055213c3ce6d0BE9B1762A732e9E059536 ??? Do this from my AddToWhitelist.aspx page. 

NOTE: If I switch my metamask browser tab account using MetaMask browser Extension (only extension properly does this every time and not when opening it up in full browser view), it WILL automatically switch the Account that is selected in remix.

*********************************************************************************************************


Deployed MyNewMinter using d537 owner: 
TSTI token address: 0xB775bAf7BF85331f654a5904330E32a7c469a216 (Note: use ATLC production value here instead)
Deployed new TokenSale using d537 owner: 0x9A1ce6cb8cB8d0213c5eD61C3628ef5d2c2a1079 (WHERE TO BUY FROM)
MyNewMinter - Minted 5000 tokens to address of TokenSale contract: 0x9A1ce6cb8cB8d0213c5eD61C3628ef5d2c2a1079,  5000000000000000000000

Note: Pass in my Production owner wallet, address of ATLC Token as 2nd parameter, use WhitelistRegistry contract address in place of 3rd parameter below, whether or not to default to using whitelist, then conversion metrics in last parameters.
Initialize: 0x832F90cf5374DC89D7f8d2d2ECb94337f54Dd537, 0xB775bAf7BF85331f654a5904330E32a7c469a216, 0xD2a8eeecb24857d1289f0f42c55307Ef190762C4, false, 20, 1
AddAdmin: 0x832F90cf5374DC89D7f8d2d2ECb94337f54Dd537 (added the tokensale contract owner as the admin)
SetWallet: 0xe8CE65fCe771bDe34fbB2Df57C3Cb15105DB8e75  (Test Account 2)
setSendToWalletEnabled : true
setWhitelistEnabled: false (I turned this off to rule out any issues with the old whitelistregistry I deployed a couple days ago)

Ensure we have some tokens to sell and the TokenSale contract has been funded:
getContractBalance: 5000000000000000000000
getContractBalanceWholeTokens: 5000  

buyTokens as 3rd account in dropdown: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
I selected 1 Ether at the top of Remix.
Clicked buyTokens button.
*************************************************************************************************************



