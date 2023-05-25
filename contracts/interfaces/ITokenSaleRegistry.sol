// SPDX-License-Identifier: Galt Project Society Construction and Terraforming Company
/*
 * Copyright ©️ 2018-2020 Galt•Project Society Construction and Terraforming Company
 * (Founded by [Nikolai Popeka](https://github.com/npopeka)
 *
 * Copyright ©️ 2018-2020 Galt•Core Blockchain Company
 * (Founded by [Nikolai Popeka](https://github.com/npopeka) by
 * [Basic Agreement](ipfs/QmaCiXUmSrP16Gz8Jdzq6AJESY1EAANmmwha15uR3c1bsS)).
 */

pragma solidity >=0.5.0 <0.9.0;
//pragma solidity ^0.5.13;


interface ITokenSaleRegistry {
  event AddWhitelistedCustomer(address indexed customer, address indexed manager);
  event RemoveWhitelistedCustomer(address indexed customer, address indexed manager);

  function validateWhitelistedCustomer(address _customer) external view;
}