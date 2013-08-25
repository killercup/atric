mongoose = require('mongoose')

Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId

Book = require('./book')

UserSchema = new Schema
  name:
    type: String
    index:
      unique: true
    required: true
    trim: true
  twitter:
    id:
      type: String
      index:
        unique: true
    token: String
    tokenSecret: String
  books: [{
    type: ObjectId
    ref: 'Book'
  }]

User = mongoose.model('User', UserSchema)

module.exports = User
