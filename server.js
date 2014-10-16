var coffeescript = require('coffee-script');
var coffeeMiddleware = require('coffee-middleware');
var express = require("express");
var expressLess = require('express-less');
var fs = require('fs');
var logfmt = require("logfmt");
var request = require('request');

var app = express();

app.use(logfmt.requestLogger());
app.use('/', express.static(__dirname + '/app'));
app.use('/bower_components', express.static(__dirname + '/bower_components'));
app.use('/styles', expressLess(__dirname + '/app/styles'));
app.use('/styles', expressLess(__dirname + '/app/plugin/styles'));
app.use(coffeeMiddleware({src: __dirname + '/app'}));

var port = Number(process.env.PORT || 8888);
app.listen(port, function() {
  console.log("Listening on " + port);
});
