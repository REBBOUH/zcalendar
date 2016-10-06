  var fs = require('fs');

  var readline = require('readline');

  var express = require('express');

  var google = require('googleapis');

  var googleAuth = require('google-auth-library');

  var passport = require('passport');

  var BasicStrategy = require('passport-http').BasicStrategy;

  var TokenStrategy = require('passport-accesstoken').Strategy;

  var jwt  = require('jsonwebtoken');

  var DataBase = require('./dataBase');

  var bodyParser = require('body-parser');

  var eventCalendar = require("./calendar");

  var prototype = require("./prototype");


  module.exports = (function() {
    'use strict';
    var apiRoutes = express.Router();

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
          console.log("info decocd "+JSON.stringify(decoded, null, 4));
          dataBase.user.getUserFromAccess(decoded,function(err,user){

           if (err) { 

            console.log('error');

            return done(err);

          }

          if (!user) { 

           console.log('passport user dont exist')

           return done(null, null);

         }; 

         console.log("passport ok");

         return done(err, user);

       })
        }
      })
    }));

  // bassic strategy 
  passport.use(new BasicStrategy(

    function(usermail, password, done) {

var user = {
  "mail":usermail,
  "password":password
}
       dataBase.user.getUserFromAccess(user,function(err,user){



        if (err) { 

          console.log('error');

          return done(err,null);

        }

        if (!user) { 

         console.log('user dont exist')

         var userError = {"mail":"error"}

         return done(err, userError);

       }; 

       return done(null, user);

     })
     }
    ));


  //function authenticate();

  apiRoutes.post('/authenticate',createUser);

  function createUser(request,response){

    console.log('/api/authenticate');


    console.log('/api/authenticate'+request.body.mail);

    console.log(" here is the body " + JSON.stringify(request.body, null, 4));
    var user = request.body;

    console.log('user connexion ***** '+user);
    
    dataBase.user.addUserAccess(user,function(err,userResult){

      if(err){

        console.log('error created user Connexion '+err);
        response.status(401).send();
      }else{

        if (user.mail == 'error') {

          response.status(401).send();

        }else{
          console.log('user connexion ***** '+JSON.stringify(userResult, null, 4));
  //console.log("user mail : "+userResult.mail+"  user password "+user.userResult);
  var token = jwt.sign({ "mail": user.mail,"password":user.password}, 'shhhhh');

  response.status(200).json({
    success: true,
    message: 'Enjoy your token!',
    token: token
  }).send();
  }
  }
  })
  }

  apiRoutes.get('/connect',passport.authenticate('basic', { session: false }),connectUser);

  function connectUser(request,response){

    console.log('/api/connect');

    if(request.err){

      console.log('error created user Connexion '+err);
      response.status(401).send();
    
    }else{

      if (request.user.mail == 'error') {
console.log('password or login not correct '+request.err);
        response.status(401).send();

      }else{
    
        console.log('user connexion ***** '+JSON.stringify(request.user, null, 4));
  //console.log("user mail : "+userResult.mail+"  user password "+user.userResult);
        var token = jwt.sign({ "mail": request.user.mail,"password":request.user.password}, 'shhhhh');

       response.status(200).json({
      success: true,
       message: 'Enjoy your token!',
     token: token
   }).send();
  }
  }
  }

  apiRoutes.use(passport.authenticate('token',{ session: false }),checkUserAuthenticate);

  function checkUserAuthenticate(request,response,next){

    console.log('checkUserAuthenticate function');

    

    console.log('passport.authenticate');

    if (!request.user) {
      return response.status(401).send({ 
        success: false, 
        message: 'No token provided.'
      });
    }

    next();

  };

  apiRoutes.use('/calendar',eventCalendar);

  return apiRoutes;
  })();

