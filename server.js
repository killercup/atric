/*
 * Start the ATRIC API server with `node server.js`.
 */

require('coffee-script');
server = require(__dirname+"/server/web.coffee");
server(process.env.PORT);