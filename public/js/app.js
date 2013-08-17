(function() {
  var API_URLs, Book, User, addBookForm, bind, books, booksTable, getMe, refreshButton, signInButton;

  API_URLs = {
    authWithTwitter: '/auth/twitter',
    logout: '/auth',
    getMe: '/users/me',
    addBook: '/users/addBook',
    removeBook: '/users/removeBook',
    getBooks: '/books'
  };

  bind = rx.bind;

  rxt.importTags();

  $(function() {
    var $alerts;
    $alerts = $('#alerts');
    return window.addAlert = function(_arg) {
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
  });

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

  addBookForm = form({
    action: API_URLs.addBook,
    method: 'POST',
    submit: function(event) {
      var _this = this;
      event.preventDefault();
      return $.ajax({
        url: $(this).attr('action'),
        method: $(this).attr('method'),
        data: {
          isbn: function() {
            return $(_this).find('[name=isbn]').val().replace('-', '');
          }
        }
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
  ]);

  booksTable = (function() {
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
  })();

  $(function() {
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

  $(function() {
    $('#actions').append((function() {
      return div([refreshButton, signInButton, addBookForm]);
    })());
    $('#main').append(booksTable);
    return getMe().success(function() {
      return $('#loading-init').remove();
    });
  });

  User = {
    name: rx.cell(),
    _id: rx.cell(),
    update: function(options) {
      var key, value, _ref, _results;
      _results = [];
      for (key in options) {
        value = options[key];
        _results.push((_ref = this[key]) != null ? _ref.set(value) : void 0);
      }
      return _results;
    }
  };

  signInButton = User._id.get() ? a({
    "class": 'btn btn-danger',
    id: 'logout',
    href: API_URLs.logout,
    click: function(event) {
      event.preventDefault();
      return $.ajax({
        url: API_URLs.logout,
        method: 'DELETE'
      }).success(function(data) {
        User.name.set(null);
        return User._id.set(null);
      });
    }
  }, 'Log Out') : a({
    "class": 'btn btn-success',
    id: 'signin',
    href: API_URLs.authWithTwitter
  }, 'Sign In');

  getMe = function() {
    return $.getJSON(API_URLs.getMe).success(function(data) {
      var arr;
      User.update({
        name: data.user.name,
        _id: data.user._id
      });
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

  refreshButton = button({
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
        return getMe().then(function() {
          return btn.attr({
            disabled: false
          });
        });
      });
    }
  }, 'Refresh');

}).call(this);

/*
//@ sourceMappingURL=app.js.map
*/