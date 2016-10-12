





//user information prototype
userInfo  = function(userJson){
  this.id = userJson.id;
  this.mail = userJson.mail;
  this.number = userJson.number;
  this.name = userJson.name;
  this.isClient = userJson.isClient;
   return this;
   console.log("userInfo prototype : **** "+this);
};

//user speciality 
userSpeciality = function(userSpeciality){
this.id = userJson.id;
  this.speciality = userJson.speciality;
  this.location = userJson.location;
  console.log(""+this);
};

event = function(eventInfo){
 this.idUser = eventInfo.idUser;
 this.idClient = eventInfo.idClient;
 this.event = eventInfo.event; 
}


module.exports.userInfo = userInfo;

module.exports.userSpeciality = userSpeciality;

module.exports.event = event;




