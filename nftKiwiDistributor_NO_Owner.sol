pragma solidity ^0.8;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ForgeDistributorContract {

    uint public totalMax = 12;
    uint public totalAmt = 0;
    uint public totalAmtKiwi = 0;
    uint public totalTimesForgeNFT = 0;
    uint public totalTimesKiwi = 0;
    uint public timestamp = block.timestamp;
    uint public timestampKiwi = block.timestamp;
    uint public length = 60 * 5; //mainnet do 60 * 60 * 24 * 31 * 2 for 2 months
    uint public ForgeNFTPer = 0;
    uint public KiwiPer = 0;
    address public forgeContract = 0xbF4493415fD1E79DcDa8cD0cAd7E5Ed65DCe7074;
    address public kiwiContract = 0xbF4493415fD1E79DcDa8cD0cAd7E5Ed65DCe7074;
    address public NFTFractionalizedContract  = 0x9265858344c8e0b3754Fc60B42DCF3ddd61fb8F9;
    
    
    constructor() public {

    }
    
    
    function mintTWO() external{
        require(timestamp < block.timestamp && timestampKiwi < block.timestamp, "Timestamp must be less than current block");
	    mintNFTShares();
    	mintKiwi();
	
	}
		
    function mintKiwi() public {
        require(timestampKiwi < block.timestamp, "timestampKiwi must be less than current block");
	    require(totalTimesKiwi<totalMax, "Deposit to continue");
	    timestampKiwi = block.timestamp + length;
	    totalTimesKiwi = totalTimesKiwi + 1;
        ERC20(kiwiContract).transfer(forgeContract, KiwiPer);
	    totalAmtKiwi = totalAmtKiwi - KiwiPer;
        // transfer the token from address of this contract
        // to address of the user (executing the withdrawToken() function)
    }
    
    
    function mintNFTShares() public {
        require(timestamp < block.timestamp, "timestamp must be less than current block");
	    require(totalTimesForgeNFT<totalMax, "Deposit to continue");
        timestamp = block.timestamp + length;
        totalTimesForgeNFT = totalTimesForgeNFT + 1;
        ERC20(NFTFractionalizedContract).transfer(forgeContract, ForgeNFTPer);
    	totalAmt = totalAmt - ForgeNFTPer;
	
        // transfer the token from address of this contract
        // to address of the user (executing the withdrawToken() function)
	
    }    
    
    
    function deposit(uint256 _amount) public {
	    require(totalAmt < _amount,"Only if you add more");
        ERC20(NFTFractionalizedContract).transferFrom(msg.sender, address(this), _amount);
        totalAmt = ( ERC20(NFTFractionalizedContract).balanceOf(address(this)) / totalMax) * totalMax;
	    ForgeNFTPer = ERC20(NFTFractionalizedContract).balanceOf(address(this)) / totalMax;
        timestamp = block.timestamp;
        // transfer the token from address of this contract
        // to address of the user (executing the withdrawToken() function)
        
            totalTimesForgeNFT = 0;
    }    
    
    
    function depositKiwi(uint256 _amount) public {
	    require(totalAmtKiwi < _amount,"Only if you add more");
        ERC20(kiwiContract).transferFrom(msg.sender, address(this), _amount);
        totalAmtKiwi = (ERC20(kiwiContract).balanceOf(address(this)) / totalMax) * totalMax;
	    KiwiPer = totalAmtKiwi / totalMax;
        timestampKiwi = block.timestamp;
	// transfer the token from address of this contract
        // to address of the user (executing the withdrawToken() function)
        
            totalTimesKiwi = 0;
    }
}
