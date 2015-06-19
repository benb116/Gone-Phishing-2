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
	var theMACAD = req.query.MACAD;
	console.log(theWANIP);

	db.Records.find({MACAddress: theMACAD}, function(err, doc) { // Try to access the database
	    console.log(doc);
	    console.log(err);
	    if (typeof doc === 'undefined' || typeof doc === null || err !== null || doc.length === 0) { // If there is no entry or something else went wrong
	    	db.Records.save({'MACAddress': theMACAD}); // Make an entry
	    	doc[0] = {};
	    }
		db.Records.update({MACAddress: theMACAD}, { $set: {"username": theuser, "password": thepass, "IP": theWANIP}, $currentDate: { lastModified: true }}); // Add a schedules block if there is none
		res.send('correct ' + theuser);
	});
});

app.use(express.static(path.join(__dirname, 'public')));

app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
});
