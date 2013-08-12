# atric - Amazon Trade In Price Check

This small script queries Amazon (.com, .de, ...) for the trade in value of the books you specify.

I wrote it because I wanted to trade stuff in but didn't want to settle for prices as low as EUR 0.10 and rather check if the values change over time.

![Screenshot](https://raw.github.com/killercup/atric/master/public/img/screenshot.png)

## Config

To use it, edit the `*.sample.yml` files to your liking and remove the 'sample' from their names.

`books.yml` needs to be a list called `books` containing the ISBN numbers of the books you want to look up.

## Usage

Running `npm start` or `coffee index.coffee --table` will output a nice table (and errors if there were any) to your terminal.

### Table Output

- `skipBelow=VALUE` hides entries with values (in cents) lower than `VALUE`. E.g., `skipBelow=11` will hide all entries with values of 10ct (and below, incl. ones without value).
- `-t nonEmpty` hides entries without values.

### JSON Output

If you want to further process the data yourself, you can use the `-o` or `--out` command line flag to write the results to a JSON file:

```sh
$ coffee index.coffee -o log.json
```

### Web Server

You can also start a simple web server which shows the data as one simple html page.

```sh
$ coffee index.coffee --web
```

In the future, I might extend this.

## Thanks

[node.js](http://nodejs.org/), [coffeescript](http://coffeescript.org/), [apac](https://github.com/dmcquay/node-apac), [cli-table](https://github.com/LearnBoost/cli-table), [express](http://expressjs.com/), [reactive-coffee](http://yang.github.io/reactive-coffee/)

## License

The MIT License (MIT)

Copyright (c) 2013 Pascal Hertleif

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
