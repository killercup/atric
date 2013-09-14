# atric - Amazon Trade In Price Check

Some time ago I wrote a small script that queried Amazon (.com, .de, ...) for the trade in value of the books you specify. I wrote it because I wanted to trade stuff in but didn't want to settle for prices as low as EUR 0.10 and rather check if the values changed over time.

Then, I wanted to try to build something with Ember.js, Express.js and MongoDB. So, I added a simple JSON API which stores historical data (see `server/`) and a web interface (see `client/`).

You can see it in action [here](http://atric.flabs.org/).

---

## Config

To use it, edit the `*.sample.yml` files to your liking and remove the 'sample' from their names.

### Requirements

As you can see in the sample config file, you need to insert some data to make ATRIC work.

If you just want to run the CLI, insert your Amazon API key ([find it here][aws]) and you're good to go.

If you want to host the web interface, there are some more requirements, which you can find in the `server` readme.

[aws]: https://portal.aws.amazon.com/gp/aws/securityCredentials

## Thanks

[node.js](http://nodejs.org/), [coffeescript](http://coffeescript.org/), [apac](https://github.com/dmcquay/node-apac), [cli-table](https://github.com/LearnBoost/cli-table), [express](http://expressjs.com/), [Ember](http://emberjs.com/), [Twitter Bootstrap](http://getbootstrap.com/), [Bootswatch](https://github.com/thomaspark/bootswatch/)

## License: MIT
