var google = require('googleapis');

var connexion = require("./connexion");
/**
 * Lists the next 10 events on the user's primary calendar.
 *
 * @param {google.auth.OAuth2} auth An authorized OAuth2 client.
 */
 var ownAouth;


console.log("calendar id "+calendarId);

connexion.connexionDataBase();

var calendarId = "zsoft-consulting.com_cdsdoimbkgpio7diamag2fh9es@group.calendar.google.com"

connexion.connexionCalendar(function(oauth2Client){
  console.log("get token aout "+oauth2Client)
  ownAouth = oauth2Client;

});

module.exports.calendarsList  =  function listCalendars(req,res) {

  var calendar = google.calendar('v3');
  calendar.calendarList.list({
    auth: ownAouth,
    maxResults: 4
  }, function(err, response) {

    if (err) {

      console.log('The API returned an error: ' + err);

      return;
    }
    var events = response.items;
    if (events.length == 0) {
      console.log('No upcoming events found.');
    } else {
      console.log(events);
    }
  }
  )
}


module.exports.list =  function listEvents(req,res) {
  var calendar = google.calendar('v3');
  calendar.events.list({
    auth: ownAouth,
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

module.exports.update = function updateEvent(req,res) {

  console.log('updating');
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
    response.summary = "RDV"
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

      console.log(response);
      res.status(200).send(); 
    })
  })
}

module.exports.calendarId = calendarId

