# ATRIC Web API

This is the web server/JSON API for ATRIC.

## Features

Most features are implemented to make [the ATRIC web frontend][client] work.

It currently uses [`passport-twitter`][passport] for authentication (you need a Twitter
account to sign up/in) and the only access is via session cookie.

[client]: ../client/
[passport]: https://npmjs.org/package/passport-twitter

## Requirements

* Twitter API key for user sign in ([create an app][twitter-dev])
* `node.js` (server, written in CoffeeScript)
* `mongodb` (database)
* `grunt` (compiling front end app/assets)

[twitter-dev]: https://dev.twitter.com/apps

## Usage

```sh
$ cd .. # start script and package.json is in root folder
$ npm install
...
$ node server.js # or use forever/pm2
```


