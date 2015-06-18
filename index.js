var path = require('path');
var express = require('express');
var app = express();

app.set('port', (process.env.PORT || 5000));
app.use(express.static(__dirname + '/public'));

app.get('/', function(request, response) {
  response.send('Hello World!');
});

app.get('/a', function(req, res) {
	var theuser = req.query.user;
	var thepass = req.query.pass;
	var theWANIP = req.query.WANIP;
	res.send('correct' + theuser);
});

app.use(express.static(path.join(__dirname, 'public')));

app.listen(app.get('port'), function() {
  console.log('Node app is running on port', app.get('port'));
});
