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


window.require.define({"books/books": function(exports, require, module) {
var App, attr;

App = require('../app');

attr = DS.attr;

App.BooksRoute = Ember.Route.extend({
  model: function() {
    return App.Book.find();
  }
});

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
  }).property('prices.@each')
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
  amazon: {
    embedded: 'always'
  },
  prices: {
    embedded: 'always'
  }
});

module["export"] = App.Book;
}});


window.require.define({"common/swag": function(exports, require, module) {
Ember.Handlebars.registerBoundHelper('truncate', function(str, params) {
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
});

Ember.Handlebars.registerBoundHelper('money', function(value, params) {
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
});
}});


window.require.define({"index": function(exports, require, module) {
var Books;

window.App = require('./app');

require('./common/swag');

require('./store');

Books = require('./books/books');

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

