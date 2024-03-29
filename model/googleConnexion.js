var fs = require('fs');
var readline = require('readline');
var google = require('googleapis');
var googleAuth = require('google-auth-library');
var express = require('express');
var mongo = require('mongodb');
var bodyParser = require('body-parser');
var app = express();
var Server = mongo.Server;
var Db = mongo.Db;
var BSON = mongo.BSONPure;

// If modifying these scopes, delete your previously saved credentials
// at ~/.credentials/calendar-nodejs-quickstart.json
var ownAuth ;

var SCOPES = ['https://www.googleapis.com/auth/calendar'];

var TOKEN_DIR = (process.env.HOME || process.env.HOMEPATH ||
	process.env.USERPROFILE) + '/.credentials/';

var TOKEN_PATH = TOKEN_DIR + 'calendar-nodejs-quickstart.json';






/**
 * Create an OAuth2 client with the given credentials, and then execute the
 * given callback function.
 *
 * @param {Object} credentials The authorization client credentials.
 * @param {function} callback The callback to call with the authorized client.
 */

 function authorize(credentials,callback) {
 	var clientSecret = credentials.installed.client_secret;
 	var clientId = credentials.installed.client_id;
 	var redirectUrl = credentials.installed.redirect_uris[0];
 	var auth = new googleAuth();
 	var oauth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl);

  // Check if we have previously stored a token.
  fs.readFile(TOKEN_PATH, function(err, token) {
  	if (err) {
  		getNewToken(oauth2Client, function(oauth){
  			callback(oauth);
  		});
  	} else {
  		oauth2Client.credentials = JSON.parse(token);
  		callback(oauth2Client);
  	}
  });
}

/**
 * Get and store new token after prompting for user authorization, and then
 * execute the given callback with the authorized OAuth2 client.
 *
 * @param {google.auth.OAuth2} oauth2Client The OAuth2 client to get token for.
 * @param {getEventsCallback} callback The callback to call with the authorized
 *     client.
 */
 function getNewToken(oauth2Client, callback) {
 	var authUrl = oauth2Client.generateAuthUrl({
 		access_type: 'offline',
 		scope: SCOPES
 	});
 	console.log('Authorize this app by visiting this url: ', authUrl);
 	var rl = readline.createInterface({
 		input: process.stdin,
 		output: process.stdout
 	});
 	rl.question('Enter the code from that page here: ', function(code) {
 		rl.close();
 		oauth2Client.getToken(code, function(err, token) {
 			if (err) {
 				console.log('Error while trying to retrieve access token', err);
 				return;
 			}
 			oauth2Client.credentials = token;
 			storeToken(token);
 			callback(oauth2Client);
 		});
 	});
 }


// Load client secrets from a local file.
module.exports.connexionGoogleCalendar = function ConnexionCalendar(callback) {
	fs.readFile('./model/client_secret.json', function processClientSecrets(err, content) {
		if (err) {
			console.log('Error loading client secret file: ' + err);
			return;
		}
  // Authorize a client with the loaded credentials, then call the
  // Google Calendar API.
  authorize(JSON.parse(content),function(oauth2Client){
  	callback(oauth2Client);  
  });
});
}
