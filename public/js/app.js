(function() {
  var API_URLs, Book, bind, books;

  bind = rx.bind;

  rxt.importTags();

  API_URLs = {
    authWithTwitter: '/auth/twitter',
    getMe: '/users/me',
    addBook: '/users/addBook',
    removeBook: '/users/removeBook',
    getBooks: '/books'
  };

  Book = (function() {
    function Book(_arg) {
      var author, image, isbn, prices, title, url, _id;
      _id = _arg._id, isbn = _arg.isbn, title = _arg.title, author = _arg.author, prices = _arg.prices, image = _arg.image, url = _arg.url;
      this._id = rx.cell(_id);
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
        return [];
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
        "class": "alert alert-" + type
      }, [
        button({
          type: 'button',
          "class": 'close',
          'data-dismiss': 'alert'
        }, '×'), msg || 'Error'
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
          id: 'signin',
          href: API_URLs.authWithTwitter
        }, 'Sign In'), form({
          action: API_URLs.addBook,
          method: 'POST',
          submit: function(event) {
            event.preventDefault();
            return $.ajax({
              url: $(this).attr('action'),
              method: $(this).attr('method'),
              data: $(this).serialize()
            }).success(function(data) {
              addAlert({
                type: 'success',
                msg: "Added " + (data.book.title || data.book.isbn)
              });
              return books.push(new Book(data.book));
            }).error(function(err) {
              return addAlert({
                type: 'danger',
                msg: err.responseText
              });
            });
          }
        }, [
          input({
            type: 'text',
            name: 'isbn',
            placeholder: 'ISBN'
          }), input({
            type: 'submit',
            "class": 'btn',
            value: 'Add'
          })
        ])
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
        thead([tr([th('ISBN'), th('Title'), th('Value')])]), tbody(books.map(function(book, index) {
          var res;
          res = tr({
            "class": 'book'
          }, [
            td(book.isbn.get()), td(book.title.get()), td([
              span([toEUR(book.currentPrice())]), span({
                "class": 'line'
              }, book.pricesList().join(','))
            ]), td([
              button({
                "class": 'btn btn-danger remove',
                'data-book_id': book._id.get(),
                'data-index': index
              }, '×')
            ])
          ]);
          res.find('.line').peity("line");
          return res;
        }))
      ]);
    })());
    refresh = function() {
      return $.getJSON(API_URLs.getMe).success(function(data) {
        var arr;
        $('#signin').hide();
        arr = data.user.books.map(function(book) {
          return new Book(book);
        });
        return books.replace(arr);
      }).error(function(err) {
        return addAlert({
          msg: err.responseText,
          type: 'warning'
        });
      });
    };
    refresh().success(function() {
      return $('#loading-init').remove();
    });
    return $(document).on('click', '.book .remove', function(event) {
      var btn;
      btn = $(this);
      btn.attr({
        disabled: true
      });
      return $.ajax({
        url: API_URLs.removeBook,
        method: 'POST',
        data: {
          book_id: btn.data('book_id')
        }
      }).then(function() {
        btn.attr({
          disabled: false
        });
        return books.removeAt(btn.data('index'));
      }).fail(function() {
        btn.attr({
          disabled: false
        });
        return addAlert({
          type: 'danger',
          msg: 'Error removing book'
        });
      });
    });
  });

}).call(this);

/*
//@ sourceMappingURL=app.js.map
*/