(function() {
  var API_URLs, Book, bind, books;

  bind = rx.bind;

  rxt.importTags();

  API_URLs = {
    getBooks: '/books.json',
    authWithTwitter: '/auth/twitter'
  };

  Book = (function() {
    function Book(_arg) {
      var author, image, isbn, prices, title, url;
      isbn = _arg.isbn, title = _arg.title, author = _arg.author, prices = _arg.prices, image = _arg.image, url = _arg.url;
      this.isbn = rx.cell(isbn);
      this.title = rx.cell(title);
      this.author = rx.cell(author);
      this.prices = rx.cell(prices);
      this.image = rx.cell(image);
      this.url = rx.cell(url);
    }

    Book.prototype.currentPrice = function() {
      var len;
      len = this.prices.get().length;
      if (!len) {
        return;
      }
      return this.prices.get()[len - 1].value;
    };

    Book.prototype.pricesList = function() {
      var p;
      p = this.prices.get();
      if (!p.length) {
        return;
      }
      return _(p).pluck('value');
    };

    return Book;

  })();

  books = rx.array();

  $(function() {
    var $alerts, addAlert, refresh;
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
    $('#actions').append((function() {
      return div([
        button({
          "class": 'btn btn-primary',
          click: function() {
            var btn;
            btn = $(this);
            btn.attr({
              disabled: true
            });
            return $.ajax({
              url: '/refresh',
              method: 'POST'
            }).then(function() {
              return refresh().then(function() {
                return btn.attr({
                  disabled: false
                });
              });
            });
          }
        }, 'Refresh'), a({
          "class": 'btn btn-success',
          href: API_URLs.authWithTwitter
        }, 'Sign In')
      ]);
    })());
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
          var res;
          res = tr([
            td(book.isbn.get()), td(book.title.get()), td([
              span([toEUR(book.currentPrice())]), span({
                "class": 'line'
              }, book.pricesList().join(','))
            ])
          ]);
          res.find('.line').peity("line");
          return res;
        }))
      ]);
    })());
    refresh = function() {
      return $.getJSON(API_URLs.getBooks).success(function(data) {
        var arr;
        _.each(data.errors, function(err) {
          return addAlert({
            msg: err,
            type: 'warning'
          });
        });
        arr = data.books.map(function(book) {
          return new Book(book);
        });
        return books.replace(arr);
      }).error(function(err) {
        return addAlert({
          msg: err,
          type: 'warning'
        });
      });
    };
    return refresh().success(function() {
      return $('#loading-init').remove();
    });
  });

}).call(this);

/*
//@ sourceMappingURL=app.js.map
*/