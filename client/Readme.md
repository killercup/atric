# ATRIC Web Client

This is a web frontend for [the ATRIC API][server], using bootstrap 3 and Ember.js.

[server]: ../server/

## Requirements

To compile app/assets:

* `grunt`
* `bower`

## Usage

```sh
$ cd .. # grunt operates on root folder
$ npm install
...
$ bower install
...
$ grunt # add 'watch' if you want grunt to run continuously
```

You can compile assets for production using `grunt precompile`.
