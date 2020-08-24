var Land = artifacts.require("./Land.sol");


contract('Land', function (accounts) {
    const Owner = accounts[0]; // owner address
    const SuperAddminAcc = accounts[2]; //superAdminAddress
     const AdminAcc= accounts[1]; //AdminAcc
     const NewOwner = accounts[4];
     let LandInstance;
     var propID = 3;
     var price = 30;
     var state = "Approved";
     
  
it("it should let us register first land ", function() {
  return Land.deployed().then(function(instance) {
    landInstance = instance;
    landInstance.createProperty(propID , price , Owner );
    return landInstance.getNumberOfLandRegistered();

  }).then(function(data) {
   
    assert.equal(data.toNumber(), 4 , "number of register land must be three");
    
  })
})
it("it should let us approve first land ", function() {
  return Land.deployed().then(function(instance) {
    landInstance = instance;
    //landInstance.approveProperty(propID , {from: SuperAddminAcc});
    return landInstance.getNumberOfApprovedLandRegistered();
  }).then(function(data) {
   
    assert.equal(data.toNumber(), 1, "number of register land must be one");
   
   
  })
})

it("it should let us reject first land ", function() {
  return Land.deployed().then(function(instance) {
    landInstance = instance;
     //landInstance.rejectProperty(propID , {from: SuperAddminAcc});
    return landInstance.getNumberOfRejectedLandRegistered();
  }).then(function(data) {
   
    assert.equal(data.toNumber(), 1, "number of register land must be one");
   
   
  })
})
it("it should let us change value of land ", function() {
  return Land.deployed().then(function(instance) {
    landInstance = instance;
    //landInstance.createProperty(propID , price , Owner );
    landInstance.changeValue( propID , 50);
    return landInstance.getPropertyDetails(propID );
  }).then(function(data) {
   
    assert.equal(data[1].toNumber() , 50 , "expected 50");
   
   
  })
})

it("it should let us change owner of land ", function() {
  return Land.deployed().then(function(instance) {
    landInstance = instance;
    //landInstance.createProperty(propID , price , Owner );
   // landInstance.createProperty(5, price , Owner );
    //landInstance.changeOwnership( 5, NewOwner);
    //landInstance.approveChangeOwnership(propID);
    return landInstance.getPropertyDetails(4);

  }).then(function(data) {
   
    assert.equal(data[2] , NewOwner , "owners should be changed");
   
   
  })
})



});




