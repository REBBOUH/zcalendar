
var express = require('express');
var bodyParser = require('body-parser');

var connexion = require('./model/connexion');
 


var app = express();

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({ extended: false }));



app.use('/api',connexion);
//app.use('/api/calendar',eventCalendar);


app.listen(8080);

