

 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;

 contract FundMe{

  address payable immutable owner;
  uint256 constant MIN_ETH = 1 wei;
  address private topContributor;
  uint256 private topBalance;
  address[] public senders;

  mapping (address => uint256) public balances;

  modifier OnlyOwner{

    require(msg.sender == owner, "only owner can withdraw the balance");
    _;
  }

  constructor(){
    owner = payable(msg.sender);
  }

  function fund() public payable{

    require(msg.value >= MIN_ETH,"not enough");
    senders.push(msg.sender);
    balances[msg.sender]=msg.value;

    if(balances[msg.sender] > topBalance){

      topBalance =balances[msg.sender];
      topContributor =msg.sender;


    }
  }

  function withdraw() external OnlyOwner{

      (bool success, ) = owner.call{value : address(this).balance}("");
      require (success, " transfer fail " );
      uint256 length = senders.length;

      for(uint i=0; i < length ; i++){
        address sender = senders[i];
        delete balances[sender];

      }

      senders = new address[](0);
    }

    function getTopContributor() public view returns (address){
      return topContributor;

    }


    receive() external payable{
      fund();
    }

    fallback() external payable{
      fund();
    }


 }