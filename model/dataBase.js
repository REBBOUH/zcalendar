


var mongo = require('mongodb');
var bodyParser = require('body-parser');

var express = require('express');

var app = express();
var Server = mongo.Server;
var Db = mongo.Db;
var BSON = mongo.BSONPure;





// connect with db 
module.exports.DataBaseModule  = function(){
	var self = this
	console.log('database module created');

	this.connexion  = {
		connexionDataBase : function(callback){

			var server = new Server('localhost', 27017, {auto_reconnect: true}); 
			var  db = new Db('easyRdv', server);

			db.open(function(err, db) {

				if(!err) {

					console.log("Connected to 'easyRdv' database");
					callback(err,db);

				}
				else{

					console.log("not Connected to 'easyRdv' database");

					callback(err,null);
				}
				
			});
		}
	};

	this.user = {

		addUserAccess : function(userInfo,callback){
			
			console.log('user add function');
			
			self.connexion.connexionDataBase(function(err,db){
				if (err) {

					console.log('error to open database '+err);
					callback(err,null);
					return;

				}


				db.collection('userAccess',function(err,collection){

					if(err) {

						console.log('error to open userAccess collection database user addUserAccess '+err  );
						callback(err,null);
						return;
					}

					self.user.getUserInfo(userInfo.mail,function(err,user){
						
						if (err) {

							console.log('error to add user atabase user addUserAccess'+err);
							return 
						}

						if (!user) {

							collection.insertOne({'login':userInfo.mail,'password':userInfo.password},{safe:true},function(err,result){

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
							callback(null,null);
						}
					});
				});
			});
},

addUserInfo: function(id,userInfo,callback){
	console.log('user add info function');
	self.connexion.connexionDataBase(function(err,db){
		if (err) {
			console.log('error to open database addUserInfo'+err);
			callback(err,null);
			return;
		}

		db.collection('userInfo',function(err,collection){

			if(err) {

				console.log('error to open userInfo collection addUserInfo');
				callback(err,null);
				return;
			}

			collection.insertOne({'_id':id,'mail':userInfo.login,'name':userInfo.name,"number":userInfo.number,"isClient":userInfo.isClient},{safe:true},function(err,result){

				if(err) {

					console.log('error to add user addUserInfo'+err);
					return 
				}
				callback(err,result);
				db.close();
			})
		})
	})
},

getUserInfo:function(mail,callback){
	
	console.log('getUserInfo');

	self.connexion.connexionDataBase(function(err,db){
		if (err) {
			console.log('error to open database addUserInfo'+err);
			callback(err,null);
			return;
		}
		db.collection('userAccess',function(err,collection){

			collection.findOne({'login':mail},{safe:true}, function (err, user) {

				if (err) { 

					console.log('error from database module getUserInfo '+err);
					db.close();
					return callback(err,null);

				}

				if (!user) { 

					db.close();
					return callback(null, null);

				}; 

				db.close();
				return callback(err, user);

			})
		})
	})
},

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
						db.close();
						return callback(err,null);

					}

					if (!user) { 

						db.close();
						return callback(null, null);

					}; 

					db.close();
					return callback(err, eventUser);

				})
			})
		})
	},
	addEventForUser:function(EventInfo,callback){
		self.connexion.connexionDataBase(function(err,db){
			if (err) {
				console.log('error to open database addEventForUser'+err);
				callback(err,null);
				return;
			}
			db.collection('event',function(err,collection){

				collection.insertOne(EventInfo,{safe:true}, function (err, eventUser) {

					if (err) { 

						console.log('error from database module addEventForUser '+err);
						db.close();
						return callback(err,null);

					}

					if (!user) { 

						db.close();
						return callback(null, null);

					}; 

					db.close();
					return callback(err, eventUser);

				})
			})
		})
	}
};
}


