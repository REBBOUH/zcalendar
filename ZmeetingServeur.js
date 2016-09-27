var fs = require('fs');
var readline = require('readline');
var google = require('googleapis');
var googleAuth = require('google-auth-library');
var express = require('express');

var app = express();
// If modifying these scopes, delete your previously saved credentials
// at ~/.credentials/calendar-nodejs-quickstart.json
var ownAuth ;
var SCOPES = ['https://www.googleapis.com/auth/calendar'];
var TOKEN_DIR = (process.env.HOME || process.env.HOMEPATH ||
  process.env.USERPROFILE) + '/.credentials/';
var TOKEN_PATH = TOKEN_DIR + 'calendar-nodejs-quickstart.json';

var calendarId = "zsoft-consulting.com_8ok1o3t4hjjfiqp2b41356g1is@group.calendar.google.com"

// Load client secrets from a local file.
fs.readFile('client_secret.json', function processClientSecrets(err, content) {
  if (err) {
    console.log('Error loading client secret file: ' + err);
    return;
  }
  // Authorize a client with the loaded credentials, then call the
  // Google Calendar API.
  authorize(JSON.parse(content));
});

/**
 * Create an OAuth2 client with the given credentials, and then execute the
 * given callback function.
 *
 * @param {Object} credentials The authorization client credentials.
 * @param {function} callback The callback to call with the authorized client.
 */
 function authorize(credentials) {
  var clientSecret = credentials.installed.client_secret;
  var clientId = credentials.installed.client_id;
  var redirectUrl = credentials.installed.redirect_uris[0];
  var auth = new googleAuth();
  var oauth2Client = new auth.OAuth2(clientId, clientSecret, redirectUrl);

  // Check if we have previously stored a token.
  fs.readFile(TOKEN_PATH, function(err, token) {
    if (err) {
      getNewToken(oauth2Client, callback);
    } else {
      oauth2Client.credentials = JSON.parse(token);
      ownAuth = oauth2Client;
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

/**
 * Store token to disk be used in later program executions.
 *
 * @param {Object} token The token to store to disk.
 */
 function storeToken(token) {
  try {
    fs.mkdirSync(TOKEN_DIR);
  } catch (err) {
    if (err.code != 'EEXIST') {
      throw err;
    }
  }
  fs.writeFile(TOKEN_PATH, JSON.stringify(token));
  console.log('Token stored to ' + TOKEN_PATH);
}

/**
 * Lists the next 10 events on the user's primary calendar.
 *
 * @param {google.auth.OAuth2} auth An authorized OAuth2 client.
 */
 function listEvents(req,res) {
  var calendar = google.calendar('v3');
  calendar.events.list({
    auth: ownAuth,
    calendarId: calendarId,
    timeMin: (new Date()).toISOString(),
    maxResults: 50,
    singleEvents: true,
    orderBy: 'startTime'
  }, function(err, response) {
    
    if (err) {
    
      console.log('The API returned an error: ' + err);
    
      return;
    }
    var events = response.items;
    if (events.length == 0) {
      console.log('No upcoming events found.');
    } else {

      console.log('Upcoming 10 events:');

      var eventsToSend = new Array(); 

      for (var i = 0; i < events.length; i++) {

        var event = events[i];

        if ( event.summary == "DSP" ) {

          eventsToSend.push(event);

          console.log('%s - %s', event.start.dateTime, event.summary);

        }
      }
      res.status(200).send(eventsToSend);
    }
  });
}

function updateEvent(req,res) {

  console.log('updating');
  var calendar = google.calendar('v3');
  calendar.events.get({
    auth: ownAuth,
    calendarId: calendarId,
    eventId: req.params.eventId
  }, function(err, response) {
    if(err) {
      console.log('The API returned an error: ' + err);
      return;
    }
    response.summary = "RDV"
   calendar.events.update({
    auth: ownAuth,
    calendarId: calendarId,
    eventId: req.params.eventId,
    resource : response
  },function(err,response){
      if (err) {
        console.log('The API returned an error: ' + err);
        return;
      }

      console.log(response);
      res.status(200).send(); 
  })
 })
}

app.get('/check',listEvents);

app.get('/update/:eventId&:eventEnd',updateEvent);

app.listen(8080);

