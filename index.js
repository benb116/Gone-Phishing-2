var path = require('path');
var express = require('express');
var bodyParser = require('body-parser');
// var mongojs = require("mongojs");

var app = express();

app.set('port', (process.env.PORT || 5000));
app.use(express.static(__dirname + '/public'));
app.use(bodyParser.text());

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
// var uri = config.MONGOUSER+':'+config.MONGOPASS+'@'+config.MONGOURI+'/peeps';
// console.log(uri)
// var db = mongojs(uri, ["Records"]);

var MongoClient = require('mongodb').MongoClient
  , assert = require('assert');

// Connection URL
var url = 'mongodb://'+config.MONGOUSER+':'+config.MONGOPASS+'@ds045882.mongolab.com:45882/peeps';
// Use connect method to connect to the Server

function Update(theMACAD, theuser, thepass, theWANIP) {
	MongoClient.connect(url, function(err, db) {
		assert.equal(null, err);
		console.log("Connected correctly to server");
		var collection = db.collection('Records');
		collection.updateOne({ MACAddress : theMACAD}, { $set:
			{
				"MACAddress": theMACAD,
				"username": theuser,
				"password": thepass,
				"IP": theWANIP
			}
		}, function(err, result) {
			console.log(err);
			// console.log(result);
			if (result.result.n != 1) {
				console.log('ee')
				collection.insert({
					"MACAddress": theMACAD,
					"username": theuser,
					"password": thepass,
					"IP": theWANIP
				}, function(err, result) {
					console.log(err)
					// console.log(result)
				});
			}
			// return "Updated the document with the field a equal to 2";
		});
	// db.close();
	});
}

app.get('/', function(request, response) {
  response.send('Hello World!');
});

app.get('/a', function(req, res) {
	var thepass = req.query.pass;
	var theuser = req.query.user;
	var theWANIP = req.query.WANIP;
	var theMACAD = req.query.MACAD;
	console.log('Pass: ' + thepass);
	Update(theMACAD, theuser, thepass, theWANIP);
	// db.Records.find({MACAddress: theMACAD}, function(err, doc) { // Try to access the database
	// 	if (err) {console.log('ERROR', err);}
	// 	console.log(doc)
	//     if (typeof doc === 'undefined' || typeof doc === null || err !== null || doc.length === 0) { // If there is no entry or something else went wrong
	//     	db.Records.save({'MACAddress': theMACAD}); // Make an entry
	//     }
	// 	db.Records.update({MACAddress: theMACAD}, { $set: {"username": theuser, "password": thepass, "IP": theWANIP}, $currentDate: { lastModified: true }}); // Add a schedules block if there is none
	// 	console.log('correct: ' + theMACAD);
	// 	res.send('correct ' + theuser);
	// });
});

// app.post('/b', function(req, res) {
// 	var theMACAD = req.query.MACAD;
// 	var rawKeychain = req.body;
// 	console.log('www')
// 	console.log(theMACAD)
// 	console.log(req);
// 	// var keyEntries = rawKeychain.split('{{');
// 	// keyEntries.shift();
// 	// var keychainJSON = {};
// 	// for (var i = keyEntries.length - 1; i >= 0; i--) {
// 	// 	var itemSplit = keyEntries[i].split(': ');
// 	// 	keychainJSON[itemSplit[0].replace(/\./g, '|')] = itemSplit[1];
// 	// }
// 	// console.log(keychainJSON);
// 	// db.Records.find({MACAddress: theMACAD}, function(err, doc) { // Try to access the database
// 	//     if (typeof doc === 'undefined' || typeof doc === null || err !== null || doc.length === 0) { // If there is no entry or something else went wrong
// 	//     	db.Records.save({'MACAddress': theMACAD}); // Make an entry
// 	//     }
// 	// 	db.Records.update({MACAddress: theMACAD}, { $set: {"keychain": keychainJSON}, $currentDate: { lastModified: true }}); // Add a schedules block if there is none
// 	// 	console.log('Keychain: ' + theMACAD);
// 	// });
// 	return res.send('correct');
// });

app.use(express.static(path.join(__dirname, 'public')));

app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
});
