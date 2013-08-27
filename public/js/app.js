(function() {
  'use strict';

  var globals = typeof window !== 'undefined' ? window : global;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};

  var has = function(object, name) {
    return ({}).hasOwnProperty.call(object, name);
  };

  var expand = function(root, name) {
    var results = [], parts, part;
    if (/^\.\.?(\/|$)/.test(name)) {
      parts = [root, name].join('/').split('/');
    } else {
      parts = name.split('/');
    }
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var dir = dirname(path);
      var absolute = expand(dir, name);
      return globals.require(absolute);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    definition(module.exports, localRequire(name), module);
    var exports = cache[name] = module.exports;
    return exports;
  };

  var require = function(name) {
    var path = expand(name, '.');

    if (has(cache, path)) return cache[path];
    if (has(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has(cache, dirIndex)) return cache[dirIndex];
    if (has(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '"');
  };

  var define = function(bundle) {
    for (var key in bundle) {
      if (has(bundle, key)) {
        modules[key] = bundle[key];
      }
    }
  }

  globals.require = require;
  globals.require.define = define;
})();

window.require.define({"app": function(exports, require, module) {
var App;

App = Ember.Application.create();

module.exports = App;
}});


window.require.define({"books/book": function(exports, require, module) {
var App, Book;

App = require('../app');

Book = require('./model');

App.PriceChartView = require('./price-chart');

App.BookController = Ember.ObjectController.extend({
  deleteBook: function() {
    var title,
      _this = this;
    title = this.get('model').get('title');
    this.get('model').one('didDelete', function() {
      alert("" + title + " deleted.");
      return _this.transitionToRoute('books');
    });
    this.get('model').deleteRecord();
    return this.get('store').commit();
  }
});

module.exports = App.BookController;
}});


window.require.define({"books/books": function(exports, require, module) {
var App, Book;

App = require('../app');

Book = require('./model');

App.BooksRoute = Ember.Route.extend({
  model: function() {
    return App.Book.find();
  }
});

App.BooksController = Ember.ArrayController.extend({
  minPrice: 42,
  newISBN: '',
  filtered: (function() {
    var minPrice, search;
    minPrice = this.get('minPrice') || 0;
    search = RegExp(this.get('searchText') || '', 'gi');
    return this.get('model').filter(function(item) {
      return (item.get('currentPrice') >= minPrice) && (search.test(item.get('title')) || search.test(item.get('author')));
    });
  }).property('minPrice', 'searchText', 'model.@each'),
  priceSum: (function() {
    return this.get('filtered').reduce((function(memo, item) {
      return memo + item.get('currentPrice');
    }), 0);
  }).property('filtered'),
  addBook: function(isbn) {
    var newBook,
      _this = this;
    newBook = App.Book.createRecord({
      isbn: isbn
    });
    newBook.one('didCreate', function() {
      _this.set('newISBN', '');
      return _this.transitionToRoute('book', newBook);
    });
    return this.get('store').commit();
  },
  refreshBooks: function() {
    return $.post('/api/refresh').then(function() {
      return window.location.reload();
    });
  }
});

module.exports = App.BooksController;
}});


window.require.define({"books/index": function(exports, require, module) {
require('./books');

require('./book');
}});


window.require.define({"books/model": function(exports, require, module) {
var App, attr;

App = require('../app');

attr = DS.attr;

App.Book = DS.Model.extend({
  isbn: attr('string'),
  title: attr('string'),
  author: attr('string'),
  prices: DS.hasMany('App.BookPrice', {
    embedded: 'load'
  }),
  amazon: DS.belongsTo('App.BookAmazon', {
    embedded: 'load'
  }),
  currentPrice: (function() {
    var _ref, _ref1, _ref2;
    return ((_ref = this.get('prices')) != null ? typeof _ref.objectAt === "function" ? (_ref1 = _ref.objectAt(((_ref2 = this.get('prices')) != null ? typeof _ref2.get === "function" ? _ref2.get('length') : void 0 : void 0) - 1)) != null ? typeof _ref1.get === "function" ? _ref1.get('value') : void 0 : void 0 : void 0 : void 0) || 0;
  }).property('prices.@each.value'),
  trend: (function() {
    var earlier, now, _ref, _ref1, _ref2;
    now = this.get('currentPrice');
    earlier = ((_ref = this.get('prices')) != null ? typeof _ref.objectAt === "function" ? (_ref1 = _ref.objectAt(((_ref2 = this.get('prices')) != null ? typeof _ref2.get === "function" ? _ref2.get('length') : void 0 : void 0) - 2)) != null ? typeof _ref1.get === "function" ? _ref1.get('value') : void 0 : void 0 : void 0 : void 0) || 0;
    if (now > earlier) {
      return 'up';
    } else if (now = earlier) {
      return 'unchanged';
    } else {
      return 'down';
    }
  }).property('currentPrice'),
  trend2glyph: (function() {
    var trend;
    trend = this.get('trend');
    if (trend === 'up') {
      "glyphicon-circle-arrow-up";
    }
    if (trend === 'down') {
      return "glyphicon-circle-arrow-down";
    } else {
      return "glyphicon-circle-arrow-right";
    }
  }).property('trend')
});

App.BookPrice = DS.Model.extend({
  value: attr('number'),
  date: attr('date'),
  book: DS.belongsTo('App.Book')
});

App.BookAmazon = DS.Model.extend({
  url: attr('string'),
  image: attr('string'),
  book: DS.belongsTo('App.Book')
});

App.RESTAdapter.map('App.Book', {
  primaryKey: '_id',
  amazon: {
    embedded: 'always'
  },
  prices: {
    embedded: 'always'
  }
});

module.exports = App.Book;
}});


window.require.define({"books/price-chart": function(exports, require, module) {
var PriceChartView, money;

money = require('common/swag').money;

PriceChartView = Ember.View.extend({
  content: [],
  valuePadding: 10,
  chartData: (function() {
    var data;
    data = [];
    this.get("content").forEach(function(item) {
      var date, value;
      date = item.get('date');
      if (date) {
        date = new Date(date);
      } else {
        if (!date) {
          return;
        }
      }
      value = item.get('value');
      if (!value) {
        return;
      }
      return data.push({
        value: value,
        date: date
      });
    });
    return data;
  }).property("content"),
  xDomain: (function() {
    return d3.extent(this.get("chartData"), function(item) {
      return item.date;
    });
  }).property("chartData"),
  yDomain: (function() {
    var padding;
    padding = this.get("valuePadding");
    return d3.extent(this.get("chartData"), function(item) {
      return item.value;
    }).map(function(value, index) {
      if (index === 0) {
        return Math.max(value - padding, 0);
      } else {
        return value + padding;
      }
    });
  }).property("chartData"),
  updateChart: (function() {
    return this.render();
  }).observes('content.@each.value'),
  didInsertElement: function() {
    return this.render();
  },
  render: (function() {
    var aspect_ratio, chart, container, data, elementId, height, line, make_marker, margin, markers, svg, width, x, xAxis, y, yAxis,
      _this = this;
    data = this.get("chartData");
    if (!(data.length > 0)) {
      return;
    }
    margin = {
      top: 20,
      right: 20,
      bottom: 50,
      left: 50
    };
    width = 420 - margin.right - margin.left;
    height = 250 - margin.top - margin.top;
    elementId = this.get("elementId");
    x = d3.time.scale().range([0, width]).domain(this.get("xDomain"));
    y = d3.scale.linear().rangeRound([height, 0]).domain(this.get("yDomain"));
    xAxis = d3.svg.axis().scale(x).orient("bottom").ticks(Math.floor(width / 75));
    yAxis = d3.svg.axis().scale(y).orient("left").ticks(Math.floor(height / 45)).tickFormat(money);
    line = d3.svg.line().interpolate("linear").x(function(item, index) {
      return x(item.date);
    }).y(function(item, index) {
      return y(item.value);
    });
    container = d3.select("#" + elementId);
    container.select('svg').remove();
    $(window).off("resize", this.get("onResize"));
    aspect_ratio = (width + margin.left + margin.right) / (height + margin.top + margin.bottom);
    this.set("onResize", function() {
      var $chart, targetWidth;
      $chart = $("#chart");
      targetWidth = $chart.parent().width();
      $chart.attr("width", targetWidth);
      return $chart.attr("height", Math.floor(targetWidth / aspect_ratio));
    });
    $(window).on("resize", this.get("onResize"));
    svg = container.append("svg").attr("id", "chart").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).attr("viewBox", "0 0 " + (width + margin.left + margin.right) + " " + (height + margin.top + margin.bottom)).attr("preserveAspectRatio", "xMidYMid");
    this.get("onResize")();
    chart = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    chart.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis);
    chart.append("g").attr("class", "y axis").call(yAxis);
    chart.append("svg:path").datum(data).attr("class", "line").attr("d", line);
    make_marker = function(group, x, y, title) {
      if (title == null) {
        title = '';
      }
      return group.append('svg:circle').attr('class', 'data-point').attr('cx', x).attr('cy', y).attr('r', 3).attr('title', title).on("mouseover", function(date, index) {
        var marker;
        marker = d3.select(this);
        marker.attr("r", 6);
        return group.append("text").attr("class", "chart-tooltip").attr("transform", "translate(" + x + "," + (y - 8) + ")").text(title);
      }).on("mouseout", function(date, index) {
        d3.select(this).attr("r", 3);
        return group.select("text").remove();
      });
    };
    markers = chart.append("svg:g").attr("class", "markers");
    data.forEach(function(item) {
      return make_marker(markers, x(item.date), y(item.value), money(item.value));
    });
    return chart;
  })
});

module.exports = PriceChartView;
}});


window.require.define({"common/swag": function(exports, require, module) {
module.exports.truncate = function(str, params) {
  var length, omission, options;
  if (str == null) {
    str = '';
  }
  if (params == null) {
    params = {};
  }
  options = params.hash || {};
  length = options.length || 90;
  omission = options.omission || '...';
  length = parseInt(length, 10);
  if (str.length > length) {
    return str.substring(0, length - omission.length) + omission;
  } else {
    return str;
  }
};

module.exports.money = function(value, params) {
  var currency, formatted_value, options, prefix;
  if (value == null) {
    value = 0;
  }
  if (params == null) {
    params = {};
  }
  options = params.hash || {};
  currency = options.currency || "€";
  prefix = options.prefix || false;
  value = parseInt(value);
  formatted_value = value > 0 ? (value / 100).toFixed(2) : 0;
  if (prefix) {
    return "" + currency + " " + formatted_value;
  } else {
    return "" + formatted_value + currency;
  }
};

Ember.Handlebars.registerBoundHelper('truncate', module.exports.truncate);

Ember.Handlebars.registerBoundHelper('money', module.exports.money);
}});


window.require.define({"index": function(exports, require, module) {
require('./common/swag');

window.App = require('./app');

require('./store');

require('./books/index');

require('./routes');
}});


window.require.define({"routes": function(exports, require, module) {
var App;

App = require('./app');

App.Router.map(function() {
  return this.resource('books', function() {
    return this.resource('book', {
      path: ':book_id'
    });
  });
});

App.IndexRoute = Ember.Route.extend({
  User: window.User,
  redirect: function() {
    if (window.User) {
      return this.transitionTo('books');
    }
  }
});
}});


window.require.define({"store": function(exports, require, module) {
var serializer;

serializer = DS.RESTSerializer.extend({
  primaryKey: function(type) {
    return '_id';
  }
});

App.RESTAdapter = DS.RESTAdapter.extend({
  namespace: 'api',
  serializer: serializer,
  serializeId: function(id) {
    return id.toString();
  }
});

App.Store = DS.Store.extend({
  adapter: App.RESTAdapter,
  revision: 13
});

module.exports = App.Store;
}});

