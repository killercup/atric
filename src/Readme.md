# ATRIC CLI

This is the command line interface for ATRIC.

![Screenshot](https://raw.github.com/killercup/atric/master/src/_screenshot.png)

## Config

See `Readme.md` in root folder for information on how to insert the data need in the `config.yml` file.

Additionally, `books.yml` needs to be a list called `books` containing the ISBN numbers of the books you want to look up.

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
