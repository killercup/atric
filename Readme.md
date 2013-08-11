# tic - Amazon Trade In Price Check

This small script queries Amazon(.com|.de|...) for the trade in value of the books you specify.

I wrote it because I wanted to trade stuff in but didn't want to settle for prices as low as EUR 0.10 and rather check if the values change over time.

## Config

To use it, edit the `*.sample.yml` files to your liking and remove the 'sample' from their names.

`books.yml` needs to be a list called `books` containing the ISBN numbers of the books you want to look up.

## Usage

Running `npm start` or `coffee index.coffee --table` will output a nice table (and errors if there were any) to your terminal.

### JSON Output

If you want to further process the data yourself, you can use the `-o` or `--out` command line flag to write the results to a JSON file:

```sh
$ coffee index.coffee -o log.json
```