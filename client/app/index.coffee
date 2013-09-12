## This file is your main application file

# Common modules
require('./common/swag')

# Initilize App
window.App = require('./app')

require('common/title')

require('./store')

# Initialize App Modules
require('./books/index')
require('./users/index')

# Initialize Routes
require('./routes')
