
var connect = require('connect');
connect.createServer(
    connect.static(__dirname+"/out")
).listen(8000);
