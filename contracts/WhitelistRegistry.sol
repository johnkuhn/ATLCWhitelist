// SPDX-License-Identifier: KuhnSoft LLC

pragma solidity >=0.6.0 <0.9.0;
//pragma solidity ^0.5.13;

import "@openzeppelin/contracts/utils/EnumerableSet.sol";
import "./interfaces/ITokenSaleRegistry.sol";
import "./traits/Managed.sol";


contract WhitelistRegistry is Managed, ITokenSaleRegistry {
    using EnumerableSet for EnumerableSet.AddressSet;

    EnumerableSet.AddressSet internal customersWhiteList;

    function initialize(address _owner) public override initializer {
        Ownable.initialize(_owner);
    }

    function addCustomerToWhiteList(address _customer) external onlyAdminOrManager payable {
        
        //ensure wallet address being set is valid
        bool isValid = isValidWalletAddress(_customer);
        require(isValid, "Invalid wallet address.");

        //ensure customer is not already in the list before adding them
        if(!customersWhiteList.contains(_customer))
        {
            //add them
            customersWhiteList.add(_customer);
            emit AddWhitelistedCustomer(_customer, msg.sender);
        }
    }

    function removeCustomerFromWhiteList(address _customer) external onlyAdminOrManager payable {

        //ensure wallet address being set is valid
        bool isValid = isValidWalletAddress(_customer);
        require(isValid, "Invalid wallet address.");

        customersWhiteList.remove(_customer);
        emit RemoveWhitelistedCustomer(_customer, msg.sender);
    }

    function isCustomerInWhiteList(address _customer) external view returns (bool) {
        return customersWhiteList.contains(_customer);
    }

    function validateWhitelistedCustomer(address _customer) external view {
        require(customersWhiteList.contains(_customer), "TokenSaleRegistry: Recipient is not in whitelist");
    }

    function getCustomersWhiteList() external view returns (address[] memory) {
      
        //JGK 5/25/23 - adjusted below code because .enumerate was throwing a compiler error. Commented out below line and replaced with loop.
        //return customersWhiteList.enumerate();

        uint256 length = customersWhiteList.length();
        address[] memory tokens = new address[](length);
        
        for (uint256 i = 0; i < length; i++) {
          tokens[i] = customersWhiteList.at(i);
        }
        
        return tokens;
    }

    function getCustomersWhiteListCount() external view returns (uint256) {
        return customersWhiteList.length();
    }

    /// @dev The isValidWalletAddress checks to make sure the address is a valid wallet address.
    /// @param walletToCheck The wallet address to check whether or not it is valid.
    /// @return true or false for whether or not the passed in wallet address is valid. 
    function isValidWalletAddress(address walletToCheck) private pure returns (bool){
        if(walletToCheck == 0x0000000000000000000000000000000000000000 ||
            walletToCheck == address(0) || 
             walletToCheck == address(0x0)) 
            return false;
         else 
            return true;
    }
}
