###
# Start server with `coffee server.coffee`
###

server = require("#{__dirname}/server/web.coffee")
server(process.env.PORT)