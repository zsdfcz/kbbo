pragma solidity ^0.5.1;

contract kbbo {

    uint private randomnonce;
    uint etheramount = 100000000000000000; //0.1 eth 100finney
    address public owner;
    string internal resulttext;
    
    struct user{
        uint kbbo;
        uint computer;
        uint bettingprice;
        uint payamount;
        uint8 result;//012
    }
    mapping(address => user) usr;
    
    constructor (string memory _random) public payable {
        randomnonce = uint(keccak256(abi.encodePacked(_random))) % 100;
        owner = msg.sender;
    }
    
	function kawibawibo(uint _kbbo) public payable{ //kbbo 0 = kawi ,1 = bawi , 2= bo
	    usr[msg.sender].bettingprice = msg.value;
	    usr[msg.sender].kbbo = _kbbo % 3;
	    require(msg.value>=etheramount&&msg.value<=30*etheramount); //0.1ether ~ 3 ether
        usr[msg.sender].payamount = msg.value * 2; 
        require(address(this).balance >=usr[msg.sender].payamount);
	    randomnonce++;
	    usr[msg.sender].computer = uint(keccak256(abi.encodePacked(now,  msg.sender, randomnonce))) % 3;
	    winnercheck();
	}
	
	function matchHistory() public view returns(string memory _computer, string memory _you, string memory){
	    string memory computer;
	    string memory you;
	    
	    if(usr[msg.sender].computer==0){
	        computer = "Scissors";
	    }
	    else if(usr[msg.sender].computer==1){
	        computer = "Rock";
	    }
	    else{
	        computer = "Paper";
	    }
	    
	    if(usr[msg.sender].kbbo==0){
	        you = "Scissors";
	    }
	    else if(usr[msg.sender].kbbo==1){
	        you = "Rock";
	    }
	    else{
	        you = "Paper";
	    }

	    return (computer,you,resulttext);
	    
	}
	
    function winnercheck() private { //true = win , false = loose
        address _addr = msg.sender; // 0 kawi 1 bawi
        if (((usr[_addr].kbbo+1)%3) == usr[_addr].computer ) 
        {   
            usr[_addr].result = 0;
            resulttext = "loose";
            // loose
        }
        else if (((usr[_addr].kbbo+2)%3) == usr[_addr].computer )
        {
            usr[_addr].result = 1;
            reward();
            resulttext = "win";

            //win
        }
        else 
        {
            usr[_addr].result = 2;
            usr[_addr].payamount /= 2 ;
            reward();
            resulttext = "draw";
            //draw
            
        } 
          
    }
	
	
	
    function reward() private{
	    //require(usr[msg.sender].result==1);
		msg.sender.transfer(usr[msg.sender].payamount);
		usr[msg.sender].result = 0;
	
	}

    function withdraw() public{
        require(msg.sender==owner);
        msg.sender.transfer(address(this).balance);
    }
    
    
    function getBalance() view public returns(uint256) {
        return address(this).balance;
    }
    
	
}


/////////////////////////
//이기는 경우의 수
//나	컴	
//가위0	보2		-> 나+2==컴 이면 이김
//바위1	가위0
//보2	바위1

//지는 경우의 수
//나	컴
//가위0	바위1		-> 나+1 ==컴 이면 짐
//바위1	보2
//보2	가위0
/////////////////////////////////
