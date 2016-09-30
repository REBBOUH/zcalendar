
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var eventCalendar = require("./model/calendar"); 




app.use(bodyParser.json());

app.use(bodyParser.urlencoded({ extended: false }));

app.get('/check/:calendarId',eventCalendar.list);

app.get('/update/:eventId&:calendarId',eventCalendar.update);

app.get('/checklist',eventCalendar.calendarsList)

app.listen(8080);

