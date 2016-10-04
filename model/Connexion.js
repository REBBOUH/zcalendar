var fs = require('fs');

var readline = require('readline');

var express = require('express');

var google = require('googleapis');

var googleAuth = require('google-auth-library');

var passport = require('passport');

var TokenStrategy = require('passport-accesstoken').Strategy;

var jwt  = require('jsonwebtoken');

var DataBase = require('./dataBase');

var bodyParser = require('body-parser');

var eventCalendar = require("./calendar");


module.exports = (function() {
  'use strict';
  var apiRoutes = express.Router();

  apiRoutes.use(bodyParser.json());

  apiRoutes.use(bodyParser.urlencoded({ extended: false }));

  var dataBase =  new DataBase.DataBaseModule;
// token strategy
var strategyOptions = {
  tokenHeader:    'x-custom-token',        
  tokenField:     'custom-token'
};

passport.use(new TokenStrategy(strategyOptions,
  function (token, done) { 
console.log("token is "+token);
    jwt.verify(token, 'shhhhh', function(err, decoded) {

      if (err) {

        return res.json({ success: false, message: 'Failed to authenticate token.' });    

      } else {
        // if everything is good, save to request for use in other routes
        console.log("info decocd "+decoded.mail);
        dataBase.user.getUserFromAccess(decoded,function(err,user){

         if (err) { 

          console.log('error');

          return done(err);

        }

        if (!user) { 

         console.log('passport user dont exist')

         return done(null, null);

       }; 

       return done(err, user);

     })
      }
    })
  }));



//function authenticate();

apiRoutes.post('/authenticate',createUser);



function createUser(request,response){

console.log('/api/authenticate');

  var user = request.body;

  console.log('user connexion ***** '+user);
  
  dataBase.user.addUserAccess(user,function(err,user){

    if(err){

      console.log('error created user Connexion '+err);
      response.status(401).send();
    }else{

      if (user.mail == 'error') {

        response.status(403).send();

      }else{

        var token = jwt.sign({ "mail": user.mail,"password":user.password }, 'shhhhh');

        response.status(200).json({
          success: true,
          message: 'Enjoy your token!',
          token: token
        }).send();
      }
    }
  })
}

apiRoutes.use(passport.authenticate('token',{ session: false }),checkUserAuthenticate);

function checkUserAuthenticate(request,response,next){

  console.log('checkUserAuthenticate function');

  

  console.log('passport.authenticate');

  if (!request.user) {
    return response.status(403).send({ 
      success: false, 
      message: 'No token provided.'
    });
  }

  next();

};

apiRoutes.use('/calendar',eventCalendar);

return apiRoutes;
})();

