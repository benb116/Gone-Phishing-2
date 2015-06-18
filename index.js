var path = require('path');
var express = require('express');
var mongojs = require("mongojs");

var app = express();

app.set('port', (process.env.PORT || 5000));
app.use(express.static(__dirname + '/public'));

var config;
try {
  config = require('./config.js');
} catch (err) { // If there is no config file
  config = {};
  config.MONGOUSER = process.env.MONGOUSER;
  config.MONGOPASS = process.env.MONGOPASS;
  config.MONGOURI = process.env.MONGOURI;
}

// Connect to database
var uri = 'mongodb://'+config.MONGOUSER+':'+config.MONGOPASS+'@'+config.MONGOURI+'/peeps'; 
var db = mongojs(uri, ["Records"]);


app.get('/', function(request, response) {
  response.send('Hello World!');
});

app.get('/a', function(req, res) {
	var thepass = req.query.pass;
	var theuser = req.query.user;
	var theWANIP = req.query.WANIP;
	res.send('correct' + theuser);
});

app.use(express.static(path.join(__dirname, 'public')));

app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
});
