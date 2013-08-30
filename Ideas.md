# Ideas

## Pricing History

**Goal:** Show how the value of my books has changed over time.

### Implementation Ideas

- Using a DB, save `books` collection with fields `isbn` and `title` and prices in seperate `prices` collection (or as subdocument) with `isbn`, `timestamp` and `value`.
- Using JS-Git, save each book as a YAML or JSON file and create a commit for each data retrieval. Then create diffs for specific files and timespans.

## Dynamic Web Interface

- Create multi user environment
  - SignIn/Up using [passport](https://npmjs.org/package/passport), i.e. Twitter or Google OAuth
  - Public collections behind obscure URL (e.g. Mongo User ID or Hash)
  - Legal repercussions?
- Allow adding of ISBNs
  - Using auto-complete from Amazon
  - `reactive.coffee` magic!
- Show product pictures and links to Amazon

### TODO

- [ ] D3 Graphs
- [x] Refresh Button
