# ATRIC Web API

This is the web server/JSON API for ATRIC.

## Features

Most features are implemented to make [the ATRIC web frontend][1] work.

It currently uses [`passport-twitter`][2] for authentication (you need a Twitter
account to sign up/in) and the only access is via session cookie.

[1]: ../client/
[2]: https://npmjs.org/package/passport-twitter

## Usage

```sh
$ cd .. # start script and package.json is in root folder
$ npm install
...
$ node server.js # or use forever/pm2
```


