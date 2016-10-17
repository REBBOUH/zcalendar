


var mongo = require('mongodb');
var bodyParser = require('body-parser');

var express = require('express');
var prototype = require('./prototype')

var app = express();
var Server = mongo.Server;
var Db = mongo.Db;
var BSON = mongo.BSONPure;


// connect with db 
function connexionDataBase(callback){

	var server = new Server('localhost', 27017, {auto_reconnect: true}); 
	db = new Db('easyRdv', server);
	db.open(function(err, db) {

		if(!err) {

			console.log("Connected to 'easyRdv' database");

			callback(err,db);

		}
		else{

			console.log("not Connected to 'easyRdv' database");
			callback(err,db);

		}
	});
}

module.exports = connexionDataBase
// connect with db 
module.exports.DataBaseModule  = function(){
	var self = this
	console.log('database module created');

	this.user = {

		addUserAccess : function(userInfo,callback){
			
			console.log('user add function');
			connexionDataBase(function(err,db){
			//self.connexion.connexionDataBase(function(err,db){
				if (!db) {

					console.log('error to open database ');
					//callback(err,null);
					return;

				}

				db.collection('userAccess',function(err,collection){

					if(err) {

						console.log('error to open userAccess collection database user addUserAccess '+err  );
						callback(err,null);
						return;
					}

					self.user.getUserFromInfo(userInfo,function(err,user){
						
						if (err) {

							console.log('error to add user atabase user addUserAccess'+err);
							return 
						}

						if (!user) {

							collection.insertOne({"mail":userInfo.mail,"password":userInfo.password},{isolated:1,unique: true },function(err,result){

								if(err) {

									console.log('error to add module database user addUserAccess '+err);
									return 

								}

								self.user.addUserInfo(result.insertedId,userInfo,function(errAdd,resultAdd){

									callback(errAdd,resultAdd);

								});
							});
						}else{
							
							console.log('user alredy exist');
							var userError = {"mail":"error"}
							callback(null,userError);
						}
					});
				});
			});
},

addUserInfo: function(id,userInfo,callback){
	console.log('user add info function');
	connexionDataBase(function(err,db){
		if (err) {
			console.log('error to open database addUserInfo'+err);
			callback(err,null);
			return;
		}

		db.collection('userInfo',function(err,collection){

			if(err) {

				console.log('error to open userInfo collection addUserInfo ' +err);
				callback(err,null);
				return;
			}
			var user = prototype.userInfo(userInfo);
			
			collection.insertOne({"_id":id,"mail":user.mail,"name":user.name,"number":user.number,"isClient":user.isClient},{isolated:1},function(err,result){

				if(err) {

					console.log('error to add user addUserInfo'+err);
					return 
				}
				callback(err,result);
			})
		})
	})
},
addUserSpeciality: function(userSpecialty,callback){
	console.log('user add info function');
	//self.connexion.connexionDataBase(function(err,db){
		if (err) {
			console.log('error to open database addUserInfo'+err);
			callback(err,null);
			return;
		}

		db.collection('userSpecialty',function(err,collection){

			if(err) {

				console.log('error to open userSpecialty collection addUserInfo');
				callback(err,null);
				return;
			}

			collection.insertOne(userSpecialty,{isolated:1},function(err,result){

				if(err) {

					console.log('error to add user addUserSpeciality'+err);
					return 
				}
				callback(err,result);
			})
		})
	//})
},
getUserFromAccess:function(user,callback){
	
	console.log('getUser');

	//self.connexion.connexionDataBase(function(err,db){
		connexionDataBase(function(err,db){
			
			if (err) {
				console.log('error to open database addUserInfo'+err);
				callback(err,null);
				return;
			}
			db.collection('userAccess',function(err,collection){

				collection.findOne({'mail':user.mail,'password':user.password}, function (err, userResult) {

					if (err) { 

						console.log('error from database module getUserInfo '+err);

						return callback(err,null);

					}

					if (!user) { 


						return callback(null, null);

					}; 

					console.log('user database found ***** '+JSON.stringify(userResult, null, 4));
					return callback(err, userResult);

				})
			})
		})
	},

	getUserFromInfo:function(user,callback){

		console.log('getUserFromInfo');

		connexionDataBase(function(err,db){
			
			if (err) {
				console.log('error to open database addUserInfo'+err);
				callback(err,null);
				return;
			}

			db.collection('userInfo',function(err,collection){
				if (err ){
					console.log('error to open database addUserInfo'+err);
					callback(err,null);
				}
				collection.findOne({'mail':user.mail}, function (err, userResult) {

					if (err) { 

						console.log('error from database module getUserFromInfo '+err);

						return callback(err,null);

					}

					if (!userResult) { 

						return callback(null, null);

					}

					return callback(err,userResult);

				})
			})
		})
	},
	getUserFromSpeciality:function(user,callback){

		console.log('getUserFromSpeciality');

	//self.connexion.connexionDataBase(function(err,db){
		if (err) {
			console.log('error to open database getUserFromSpeciality'+err);
			callback(err,null);
			return;
		}
		db.collection('userSpecialty',function(err,collection){

			collection.findOne({'mail':user.mail},{safe:true}, function (err, user) {

				if (err) { 

					console.log('error from database module getUserFromSpeciality '+err);

					return callback(err,null);

				}

				if (!user) { 


					return callback(null, null);

				}; 

				
				return callback(err, user);

			})
		})
	//})
}

};

this.eventCalendar = {
	getEventForUser:function(idUser,callback){
		self.connexion.connexionDataBase(function(err,db){
			if (err) {
				console.log('error to open database getEventForUser'+err);
				callback(err,null);
				return;
			}
			db.collection('event',function(err,collection){

				collection.findMany({'id_user':idUser},{safe:true}, function (err, eventUser) {

					if (err) { 

						console.log('error from database module getEventForUser '+err);
						
						return callback(err,null);

					}

					if (!user) { 


						return callback(null, null);

					}; 


					return callback(err, eventUser);

				})
			})
		})
	},
	addEventForUser:function(EventInfo,callback){
	//	self.connexion.connexionDataBase(function(err,db){
		if (err) {
			console.log('error to open database addEventForUser'+err);
			callback(err,null);
			return;
		}
		db.collection('event',function(err,collection){

			collection.insertOne(EventInfo,{isolated:1}, function (err, eventUser) {

				if (err) { 

					console.log('error from database module addEventForUser '+err);

					return callback(err,null);

				}

				if (!user) { 

					
					return callback(null, null);

				}; 

				
				return callback(err, eventUser);

			})
		})
	//	})
}
};
}


