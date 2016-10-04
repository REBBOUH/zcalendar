var google = require('googleapis');

var connexion = require("./googleConnexion");

var DataBase = require('./dataBase');

var express = require('express');

var bodyParser = require('body-parser');

/**
 * Lists the next 10 events on the user's primary calendar.
 *
 * @param {google.auth.OAuth2} auth An authorized OAuth2 client.
 */

 module.exports = (function() {
   var ownAouth;

   'use strict';
   var apiRoutes = express.Router();

   apiRoutes.use(bodyParser.json());

   apiRoutes.use(bodyParser.urlencoded({ extended: false }));
   var calendar = google.calendar('v3');

   connexion.connexionGoogleCalendar(function(oauth2Client){
    console.log("OAuth2 ")
    ownAouth = oauth2Client;

  });




   function listCalendars(req,res) {

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

        res.status(200).send(response);

      }
    }
    )
  }


  function listEvents(req,res) {
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

  function updateEvent(req,res) {
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
  apiRoutes.get('/check/:calendarId',listEvents);
  apiRoutes.get('/update/:eventId&:calendarId',updateEvent);
  apiRoutes.get('/checklist',listCalendars)
  return apiRoutes;
})();
