var google = require('googleapis');

var connexion = require("./connexion");

var DataBase = require('./dataBase');
/**
 * Lists the next 10 events on the user's primary calendar.
 *
 * @param {google.auth.OAuth2} auth An authorized OAuth2 client.
 */
 var ownAouth;

var calendar = google.calendar('v3');
var dataBase =  new DataBase.DataBaseModule;

connexion.connexionCalendar(function(oauth2Client){
  console.log("OAuth2 ")
  ownAouth = oauth2Client;

});

module.exports.calendarsList  =  function listCalendars(req,res) {
  
  calendar.calendarList.list({
    auth: ownAouth,
    minAccessRole:"owner",
    maxResults: 100
  }, function(err, response) {

    if (err) {

      console.log('The API returned an error: ' + err);

      return;
    }
    var events = response.items;
    if (events.length == 0) {
      console.log('no calendar found.');
    } else {
      dataBase.user.addUserAccess({mail:'yassir@aberni.fr',password:'yassirOk',number:'0656094059',isClient:false},function(err,result){
        if (err || !result) {
          console.log('error from calendar module ');
          res.status(401).send();
        }else{
          console.log('result  '+result.insertedId);
          res.status(200).send(response);
        }
      })
      
    }
  }
  )
}


module.exports.list =  function listEvents(req,res) {
  console.log(req.params.calendarId);
  var calendar = google.calendar('v3');
  calendar.events.list({
    auth: ownAouth,
    calendarId: req.params.calendarId,
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
      res.status(200).send();
    } else {
      var eventsToSend = [];
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

module.exports.update = function updateEvent(req,res) {
var calendarId = req.params.calendarId;
  console.log('updating '+req.params.calendarId+' event Id '+req.params.eventId);
  var calendar = google.calendar('v3');
  calendar.events.get({
    auth: ownAouth,
    calendarId: calendarId,
    eventId: req.params.eventId
  }, function(err, response) {
    if(err) {
      console.log('The API returned an error: ' + err);
      return;
    }
    response.summary = "RDV",
    response.colorId = "2"
    calendar.events.update({
      auth: ownAouth,
      calendarId: calendarId,
      eventId: req.params.eventId,
      resource : response
    },function(err,response){
      if (err) {
        console.log('The API returned an error: ' + err);
        return;
      }

      
      res.status(200).send(); 
    })
  })
}


