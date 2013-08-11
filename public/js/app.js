(function() {
  var Book, DATA_URL, bind, books;

  bind = rx.bind;

  rxt.importTags();

  DATA_URL = '/data.json';

  Book = (function() {
    function Book(_arg) {
      var author, image, isbn, title, url, value;
      isbn = _arg.isbn, title = _arg.title, author = _arg.author, value = _arg.value, image = _arg.image, url = _arg.url;
      this.isbn = rx.cell(isbn);
      this.title = rx.cell(title);
      this.author = rx.cell(author);
      this.value = rx.cell(value);
      this.image = rx.cell(image);
      this.url = rx.cell(url);
    }

    return Book;

  })();

  books = rx.array();

  $(function() {
    var $alerts, addAlert;
    $alerts = $('#alerts');
    addAlert = function(_arg) {
      var msg, type;
      msg = _arg.msg, type = _arg.type;
      return $alerts.append(div({
        "class": 'alert alert-#{type}'
      }, [
        button({
          type: 'button',
          "class": 'close'
        }, ['&times;']), msg
      ]));
    };
    $('#main').append((function() {
      var toEUR;
      toEUR = function(value) {
        var text;
        if (value == null) {
          value = 0;
        }
        text = "" + ((value / 100).toFixed(2)) + "€";
        if (value > 100) {
          return strong({
            style: 'color: green;'
          }, text);
        }
        if (value > 10) {
          return strong(text);
        } else {
          return span(text);
        }
      };
      return table({
        "class": 'table'
      }, [
        thead([tr([th('ISBN'), th('Title'), th('Value')])]), tbody(books.map(function(book) {
          return tr([td(book.isbn.get()), td(book.title.get()), td([toEUR(book.value.get())])]);
        }))
      ]);
    })());
    return $.getJSON(DATA_URL).success(function(data) {
      $('#loading-init').remove();
      _.each(data.errors, function(err) {
        return addAlert({
          msg: err,
          type: 'warning'
        });
      });
      return _.each(data.books, function(book) {
        return books.push(new Book(book));
      });
    }).error(function(err) {
      return addAlert({
        msg: err,
        type: 'warning'
      });
    });
  });

}).call(this);

/*
//@ sourceMappingURL=app.js.map
*/