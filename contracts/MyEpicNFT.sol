// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 maxTokens = 50;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.

    string coolSvg="<svg xmlns='http://www.w3.org/2000/svg' width='100%' height='100%' viewBox='0 0 100 60'><rect fill='#cc5577' width='100' height='60'/><g ><rect fill='#cc5577' width='11' height='11'/><rect fill='#ce5776' x='10' width='11' height='11'/><rect fill='#d05a76' y='10' width='11' height='11'/><rect fill='#d15c75' x='20' width='11' height='11'/><rect fill='#d35f74' x='10' y='10' width='11' height='11'/><rect fill='#d46174' y='20' width='11' height='11'/><rect fill='#d66473' x='30' width='11' height='11'/><rect fill='#d76673' x='20' y='10' width='11' height='11'/><rect fill='#d96972' x='10' y='20' width='11' height='11'/><rect fill='#da6c72' y='30' width='11' height='11'/><rect fill='#db6e71' x='40' width='11' height='11'/><rect fill='#dc7171' x='30' y='10' width='11' height='11'/><rect fill='#dd7471' x='20' y='20' width='11' height='11'/><rect fill='#de7671' x='10' y='30' width='11' height='11'/><rect fill='#df7971' y='40' width='11' height='11'/><rect fill='#e07c71' x='50' width='11' height='11'/><rect fill='#e17e71' x='40' y='10' width='11' height='11'/><rect fill='#e28171' x='30' y='20' width='11' height='11'/><rect fill='#e38471' x='20' y='30' width='11' height='11'/><rect fill='#e38771' x='10' y='40' width='11' height='11'/><rect fill='#e48972' y='50' width='11' height='11'/><rect fill='#e58c72' x='60' width='11' height='11'/><rect fill='#e58f73' x='50' y='10' width='11' height='11'/><rect fill='#e69173' x='40' y='20' width='11' height='11'/><rect fill='#e69474' x='30' y='30' width='11' height='11'/><rect fill='#e79775' x='20' y='40' width='11' height='11'/><rect fill='#e79a75' x='10' y='50' width='11' height='11'/><rect fill='#e89c76' x='70' width='11' height='11'/><rect fill='#e89f77' x='60' y='10' width='11' height='11'/><rect fill='#e8a278' x='50' y='20' width='11' height='11'/><rect fill='#e9a47a' x='40' y='30' width='11' height='11'/><rect fill='#e9a77b' x='30' y='40' width='11' height='11'/><rect fill='#e9aa7c' x='20' y='50' width='11' height='11'/><rect fill='#e9ac7e' x='80' width='11' height='11'/><rect fill='#eaaf7f' x='70' y='10' width='11' height='11'/><rect fill='#eab281' x='60' y='20' width='11' height='11'/><rect fill='#eab482' x='50' y='30' width='11' height='11'/><rect fill='#eab784' x='40' y='40' width='11' height='11'/><rect fill='#eaba86' x='30' y='50' width='11' height='11'/><rect fill='#ebbc88' x='90' width='11' height='11'/><rect fill='#ebbf8a' x='80' y='10' width='11' height='11'/><rect fill='#ebc18c' x='70' y='20' width='11' height='11'/><rect fill='#ebc48e' x='60' y='30' width='11' height='11'/><rect fill='#ebc790' x='50' y='40' width='11' height='11'/><rect fill='#ebc992' x='40' y='50' width='11' height='11'/><rect fill='#ebcc94' x='90' y='10' width='11' height='11'/><rect fill='#ebce97' x='80' y='20' width='11' height='11'/><rect fill='#ebd199' x='70' y='30' width='11' height='11'/><rect fill='#ecd39c' x='60' y='40' width='11' height='11'/><rect fill='#ecd69e' x='50' y='50' width='11' height='11'/><rect fill='#ecd8a1' x='90' y='20' width='11' height='11'/><rect fill='#ecdba4' x='80' y='30' width='11' height='11'/><rect fill='#ecdda6' x='70' y='40' width='11' height='11'/><rect fill='#ece0a9' x='60' y='50' width='11' height='11'/><rect fill='#ede2ac' x='90' y='30' width='11' height='11'/><rect fill='#ede4af' x='80' y='40' width='11' height='11'/><rect fill='#ede7b2' x='70' y='50' width='11' height='11'/><rect fill='#ede9b5' x='90' y='40' width='11' height='11'/><rect fill='#eeecb8' x='80' y='50' width='11' height='11'/><rect fill='#EEB' x='90' y='50' width='11' height='11'/></g><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle' text-size='50%'>";
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";


    // I create three arrays, each with their own theme of random words.
    // Pick some random funny words, names of anime characters, foods you like, whatever! 
    string[] firstWords = ["Reviving", "Cool", "Restoring", "Awesome", "Stimulating", "Thrilling", "Soothing", "Refreshing", "Energizing", "Calm", "Spicy"];
    string[] secondWords = ["Seokjin", "Namjoon", "Yoongi", "Hoseok", "Jimin", "Taehyung", "Jungkook"];
    string[] thirdWords = ["Coffee", "World", "Hotcholoate", "Star", "Syrup", "Movie", "Latte", "Cha", "Americano", "Cappucino", "Espresso", "Mocha", "Machiato"];

    event NewEpicNFTMinted(address sender, uint256 tokenId);


    constructor() ERC721 ("BoxNFT", "BLACKBOXES"){
        console.log("This is my NFT contract. Whoa!");
    }

    function pickWords(uint256 tokenId) public view returns (string memory){
        uint256 rand1 = random(string(abi.encodePacked("FIRST", tokenId)));
        uint256 rand2 = random(string(abi.encodePacked("SECOND", tokenId)));
        uint256 rand3 = random(string(abi.encodePacked("THIRD", tokenId)));

        return string(abi.encodePacked(firstWords[rand1%firstWords.length],  secondWords[rand2%secondWords.length],  thirdWords[rand3%thirdWords.length]));
    }

    function random(string memory input) internal pure returns (uint256){
         return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {

        require(numberOfNFTMinted()<maxTokens, "Max NFT mint limit reached!");

        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();
        // Actually mint the NFT to the sender using msg.sender.
        _safeMint(msg.sender, newItemId);

        string memory words = pickWords(newItemId);

        // I concatenate it all together, and then close the <text> and <svg> tags.
        string memory finalSvg = string(abi.encodePacked(baseSvg, words, "</text></svg>"));
        console.log("\n--------------------");
        console.log(finalSvg);
        console.log("--------------------\n");

         // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    words,
                    '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

     // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

     console.log("\n--------------------");
     console.log(
        string(
            abi.encodePacked(
                "https://nftpreview.0xdev.codes/?code=",
                finalTokenUri
            )
        )
    );
    console.log("--------------------\n");


        // Set the NFTs data.
        _setTokenURI(newItemId, finalTokenUri);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        emit NewEpicNFTMinted(msg.sender, newItemId);

        // Increment the counter for when the next NFT is minted.
        _tokenIds.increment();
    }

    function numberOfNFTMinted() public view returns (uint256){
        return _tokenIds.current();
    }
}