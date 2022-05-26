// SPDX-License-Identifier: MIT
// Contract Deployed at: 0xEf566CA788FCDc826A24cF23854eEc13B5FF7E2B

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    
    //Defining structs for Stats
    struct Stats{
        uint levels;
        uint strength;
        uint speed;
        uint life;
    }

    mapping (uint256 => Stats) tokenIdToStats;
   

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    function generateCharacter(uint256 tokenId) public view returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels:",getLevels(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength:",getStrength(tokenId),'</text>'
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed:",getSpeed(tokenId),'</text>'
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life:",getLife(tokenId),'</text>'
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdToStats[tokenId].levels;
    return levels.toString();
}
    function getStrength(uint256 tokenId) public view returns (string memory){
        uint256 strength = tokenIdToStats[tokenId].strength;
        return strength.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
    uint256 speed = tokenIdToStats[tokenId].speed;
    return speed.toString();}

    function getLife(uint256 tokenId) public view returns (string memory) {
    uint256 life = tokenIdToStats[tokenId].life;
    return life.toString();}


function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}

//Define a random number
//Initializing the state variable

uint randNonce = 0;

//Defining a function to generate a random number

function randMod(uint _modulus) internal returns(uint) {
    //increase nonce
    randNonce++;
    return uint(keccak256(abi.encodePacked(block.timestamp,msg.sender, randNonce))) % _modulus;
}

function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    tokenIdToStats[newItemId].levels = 0;
    tokenIdToStats[newItemId].strength = 0;
    tokenIdToStats[newItemId].speed = 0;
    tokenIdToStats[newItemId].life = 0;

    _setTokenURI(newItemId, getTokenURI(newItemId));
}
 function train(uint256 tokenId) public {
   require(_exists(tokenId));
   require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
   uint256 currentLevel = tokenIdToStats[tokenId].levels;
   tokenIdToStats[tokenId].levels = currentLevel + 1;
// increase strength
    uint256 currentStrength = tokenIdToStats[tokenId].strength;
    tokenIdToStats[tokenId].strength = currentStrength + randMod(10);
// increase Speed
    uint256 currentSpeed = tokenIdToStats[tokenId].speed;
    tokenIdToStats[tokenId].speed = currentSpeed + randMod(20);
// increase life
    uint256 currentLife = tokenIdToStats[tokenId].life;
    tokenIdToStats[tokenId].life = currentLife + randMod(10);


   _setTokenURI(tokenId, getTokenURI(tokenId));
}

}