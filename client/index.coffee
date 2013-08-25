## This file is your main application file
## You will require all parts of your application here

window.App = require('./app')

require('./common/swag')

require('./store')

Books = require('./books/index')

require('./routes')
