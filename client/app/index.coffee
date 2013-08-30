## This file is your main application file

# Common modules
require('./common/swag')

# Initilize App
window.App = require('./app')
require('./store')

# Initialize App Modules
require('./books/index')

# Initialize Routes
require('./routes')
