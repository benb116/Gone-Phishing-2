var util = require('util');

module.exports = function(arr, iterator, cb) {
	var i = 0;
	if (!cb) cb = function() {};
 
	var loop = function() {
		if (i >= arr.length) return cb();
		iterator(arr[i], i, function(err) {
			if (util.isError(err)) return cb(err);
			process.nextTick(loop);
		});
		i++;
	};
 
	loop();
};
