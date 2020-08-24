// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16;

contract Land {

    address public creatorAdmin;
	address constant public owner = 0x0C9Fcd29682428607d2E39c948d5614bfAAEB333;
	address constant public NewOwner = 0x339B9E209b6c71851FBf4f43715fBA05E9DF052b;

	//status of the land registered 
	uint landListCounter;
	uint landApprovedCounter;
	uint landRejectedCounter;

	enum Status { NotExist, Pending, Approved, Rejected }

	struct PropertyDetail {
		Status status;
		uint value;
		address currOwner;
	}
	

	// Dictionary of all the properties, mapped using their { propertyId: PropertyDetail } pair.
	mapping(uint => PropertyDetail) public properties;
	mapping(uint => address) public propOwnerChange;

    mapping(address => int) public users;
    mapping(address => bool) public verifiedUsers;

  //modifiers....

	modifier onlyOwner(uint _propId) {
		require(properties[_propId].currOwner == msg.sender);
		_;
	}

	modifier verifiedUser(address _user) {
	    require(verifiedUsers[_user]);
	    _;
	}

	modifier verifiedAdmin() {
		require(users[msg.sender] >= 2 && verifiedUsers[msg.sender]);
		_;
	}

	modifier verifiedSuperAdmin() {
	    require(users[msg.sender] == 3 && verifiedUsers[msg.sender]);
	    _;
	}

	//events.... 

	//checked
	event LandOwnerChanged(
        uint _propID
    );
    //checked
    event LandPriceChanged(
        uint _propID,
        uint price
    );
    
    event LandAvailabilityChanged(
        uint _propID,
        //uint price,
        Status status
    );

	 // PropertyDetail [3] public lands;

	// Initializing the User Contract.
	constructor() public {
	creatorAdmin = msg.sender;
		users[creatorAdmin] = 3;
		verifiedUsers[creatorAdmin] = true;
		//properties[1] = PropertyDetail(Status.NotExist,10 , owner);
        verifiedUsers[NewOwner] = true;
         createProperty(1,10, owner);
		 approveProperty(1);
		 createProperty(2,20, owner);
		 rejectProperty(2);
		 createProperty(4,40, owner);
		 // approveProperty(4);
		 changeOwnership( 4, NewOwner);
		 approveChangeOwnership(4);


		 //landListCounter =1;
		 ///changeValue(1, 50);




        
		
	}

	// Create a new Property.
	function createProperty(uint _propId, uint _value, address _owner)  public    {
		properties[_propId] = PropertyDetail(Status.Pending, _value, _owner);
		 landListCounter++;
	}

	// Approve the new Property.
	function approveProperty(uint _propId) public  verifiedSuperAdmin {
		require(properties[_propId].currOwner != msg.sender);
		properties[_propId].status = Status.Approved;
		emit LandAvailabilityChanged ( _propId ,properties[_propId].status );
		landApprovedCounter++;

		

	
	}

	// Reject the new Property.
	function rejectProperty(uint _propId) public verifiedSuperAdmin {
		require(properties[_propId].currOwner != msg.sender);
		properties[_propId].status = Status.Rejected;
		emit LandAvailabilityChanged ( _propId ,properties[_propId].status );
		
	landRejectedCounter++;
  
		
	}

	// Request Change of Ownership.
	function changeOwnership(uint _propId, address _newOwner) public verifiedUser(_newOwner) verifiedAdmin  {
		require(properties[_propId].currOwner != _newOwner);
		require(propOwnerChange[_propId] == address(0));
		propOwnerChange[_propId] = _newOwner;
		
	}
	 function getNumberOfLandRegistered() public view returns (uint) {
    return landListCounter;
  }

  function getNumberOfApprovedLandRegistered() public view returns (uint) {
    return landApprovedCounter;
  }
  function getNumberOfRejectedLandRegistered() public view returns (uint) {
    return landRejectedCounter;
  }

	// Approve chage in Onwership.
	function approveChangeOwnership(uint _propId) public verifiedSuperAdmin  {
	    require(propOwnerChange[_propId] != address(0));
	    properties[_propId].currOwner = propOwnerChange[_propId];
	    propOwnerChange[_propId] = address(0);
        emit LandOwnerChanged(_propId);
	    
	}

    function changeValue(uint _propId, uint _newValue) public onlyOwner(_propId)  {
        require(propOwnerChange[_propId] == address(0));
        properties[_propId].value = _newValue;
		emit LandPriceChanged(_propId , _newValue);
		//return _newValue;
       
    }

	// Get the property details.
	function getPropertyDetails(uint _propId)  public view returns (Status, uint, address) {
		return (properties[_propId].status, properties[_propId].value, properties[_propId].currOwner);
	}
    //Get all the properties details
	function getPropertiesDetails(uint [] memory _propIds)  public view returns (Status [] memory ,uint [] memory , address [] memory) {
		address[] memory addrs ;
        uint[] memory price ;
		Status [] memory status;
		for (uint i = 0; i < _propIds.length; i++){
            addrs[i] = properties[i].currOwner;
            price[i] = properties[i].value;
			status[i] = properties[i].status;

            
		}
		return (status, price , addrs);
	}

	// Add new user.
	function addNewUser(address _newUser) public verifiedAdmin  {
	    require(users[_newUser] == 0);
	    require(verifiedUsers[_newUser] == false);
	    users[_newUser] = 1;
	    
	}

	// Add new Admin.
	function addNewAdmin(address _newAdmin) public verifiedSuperAdmin  {
	    require(users[_newAdmin] == 0);
	    require(verifiedUsers[_newAdmin] == false);
	    users[_newAdmin] = 2;
	    
	}

	// Add new SuperAdmin.
	function addNewSuperAdmin(address _newSuperAdmin) public verifiedSuperAdmin  {
	    require(users[_newSuperAdmin] == 0);
	    require(verifiedUsers[_newSuperAdmin] == false);
	    users[_newSuperAdmin] = 3;
	    
	}

	// Approve User.
	function approveUsers(address _newUser) public verifiedSuperAdmin  {
	    require(users[_newUser] != 0);
	    verifiedUsers[_newUser] = true;
	    
	}
}