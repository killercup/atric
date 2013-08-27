require('coffee-script');
port = process.env.PORT || 3000;
server = require(__dirname+"/src/web.coffee")
server(port);