/*
 * Copyright ©️ 2018-2020 Galt•Project Society Construction and Terraforming Company
 * (Founded by [Nikolai Popeka](https://github.com/npopeka)
 *
 * Copyright ©️ 2018-2020 Galt•Core Blockchain Company
 * (Founded by [Nikolai Popeka](https://github.com/npopeka) by
 * [Basic Agreement](ipfs/QmaCiXUmSrP16Gz8Jdzq6AJESY1EAANmmwha15uR3c1bsS)).
 */
pragma solidity >=0.6.0 <0.8.2;
//pragma solidity ^0.5.13;

import "@openzeppelin/contracts/utils/EnumerableSet.sol";

import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/ownership/Ownable.sol";


contract Administrated is Initializable, Ownable {
  using EnumerableSet for EnumerableSet.AddressSet;

  event AddAdmin(address indexed admin);
  event RemoveAdmin(address indexed admin);

  EnumerableSet.AddressSet internal admins;

  modifier onlyAdmin() {
    require(isAdmin(msg.sender), "Administrated: Msg sender is not admin");
    _;
  }
  constructor() public {
  }

  function addAdmin(address _admin) external onlyOwner {
    admins.add(_admin);
    emit AddAdmin(_admin);
  }

  function removeAdmin(address _admin) external onlyOwner {
    admins.remove(_admin);
    emit RemoveAdmin(_admin);
  }

  function isAdmin(address _admin) public view returns (bool) {
    return admins.contains(_admin);
  }

  function getAdminList() external view returns (address[] memory) {
    return admins.enumerate();
  }

  function getAdminCount() external view returns (uint256) {
    return admins.length();
  }
}
