Ember.TEMPLATES["application"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
  var buffer = '', stack1, hashTypes, hashContexts, escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = '', hashTypes, hashContexts;
  data.buffer.push("\n<nav class=\"navbar navbar-default\" role=\"navigation\">\n  <div class=\"container\">\n    <a class=\"navbar-brand\" href=\"#\">\n      <abbr title=\"Amazon Trade In Price Checker\">ATRIC</abbr>\n    </a>\n\n    <ul class=\"nav navbar-nav navbar-right\">\n      <li class=\"navbar-text\">\n        Hi, ");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers._triageMustache.call(depth0, "User.name", {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push(".\n      </li>\n      <li>\n        <a href=\"/api/logout\">Logout</a>\n      </li>\n    </ul>\n  </div>\n</nav>\n\n<div class=\"container\">\n  ");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers._triageMustache.call(depth0, "outlet", {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("\n</div>\n");
  return buffer;
  }

function program3(depth0,data) {
  
  
  data.buffer.push("\n\n<div class=\"container\">\n  <div class=\"jumbotron\">\n    <h1>\n      Amazon Trade In Price Checker\n    </h1>\n    <p>\n      Enter some book ISBNs and get a list of what they're worth on <a href=\"http://www.amazon.de/b?_encoding=UTF8&camp=1638&creative=6742&linkCode=ur2&node=186606&site-redirect=de&tag=killercblog-21\">Amazon.de</a>\n    </p>\n    <p>\n      <a class=\"btn btn-success btn-large\" href=\"/api/auth/twitter\">Sign in with Twitter</a>\n    </p>\n  </div>\n</div>\n");
  }

  hashTypes = {};
  hashContexts = {};
  stack1 = helpers['if'].call(depth0, "User", {hash:{},inverse:self.program(3, program3, data),fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data});
  if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
  data.buffer.push("\n\n<footer class=\"container\">\n  <p class=\"text-center\">\n    ATRIC is an <a href=\"https://github.com/killercup/atric\">open source</a> project by <a href=\"http://pascalhertleif.de/\">Pascal Hertleif</a>.\n  </p>\n</footer>");
  return buffer;
  
});

Ember.TEMPLATES["book"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
  var buffer = '', stack1, stack2, hashTypes, hashContexts, options, escapeExpression=this.escapeExpression, self=this, helperMissing=helpers.helperMissing;

function program1(depth0,data) {
  
  var buffer = '', hashTypes, hashContexts;
  data.buffer.push("\n      <small>by ");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers._triageMustache.call(depth0, "author", {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("</small>\n      ");
  return buffer;
  }

function program3(depth0,data) {
  
  var buffer = '', hashContexts, hashTypes;
  data.buffer.push("\n      <a ");
  hashContexts = {'href': depth0};
  hashTypes = {'href': "ID"};
  data.buffer.push(escapeExpression(helpers.bindAttr.call(depth0, {hash:{
    'href': ("amazon.url")
  },contexts:[],types:[],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push(" title=\"View on Amazon\">\n        <p>\n          <img ");
  hashContexts = {'src': depth0};
  hashTypes = {'src': "STRING"};
  data.buffer.push(escapeExpression(helpers.bindAttr.call(depth0, {hash:{
    'src': ("amazon.image")
  },contexts:[],types:[],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push(" alt=\"Cover\" class=\"thumbnail\" />\n        </p>\n        <p>\n          View on Amazon\n        </p>\n      </a>\n      <p><small class=\"text-muted\">\n        ISBN: ");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers._triageMustache.call(depth0, "isbn", {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("\n      </small></p>\n    ");
  return buffer;
  }

  data.buffer.push("<article class=\"book panel panel-default\">\n  <header class=\"panel-heading\">\n    <h1>\n      ");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers._triageMustache.call(depth0, "title", {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("\n      ");
  hashTypes = {};
  hashContexts = {};
  stack1 = helpers['if'].call(depth0, "author", {hash:{},inverse:self.noop,fn:self.program(1, program1, data),contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data});
  if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
  data.buffer.push("\n    </h1>\n  </header>\n  <div class=\"row panel-body\">\n    <div class=\"col-md-8\">\n      <p class=\"text-info\">\n        <strong>Current value:</strong>\n        ");
  hashTypes = {};
  hashContexts = {};
  options = {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data};
  data.buffer.push(escapeExpression(((stack1 = helpers.money || depth0.money),stack1 ? stack1.call(depth0, "currentPrice", options) : helperMissing.call(depth0, "money", "currentPrice", options))));
  data.buffer.push("\n      </p>\n\n      ");
  hashContexts = {'contentBinding': depth0};
  hashTypes = {'contentBinding': "STRING"};
  data.buffer.push(escapeExpression(helpers.view.call(depth0, "App.PriceChartView", {hash:{
    'contentBinding': ("prices")
  },contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("\n    </div>\n    <div class=\"col-md-4\">\n    ");
  hashTypes = {};
  hashContexts = {};
  stack2 = helpers['if'].call(depth0, "amazon", {hash:{},inverse:self.noop,fn:self.program(3, program3, data),contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data});
  if(stack2 || stack2 === 0) { data.buffer.push(stack2); }
  data.buffer.push("\n    </div>\n  </div>\n\n  <footer class=\"panel-footer clearfix\">\n    <button class=\"pull-right btn btn-danger\"");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers.action.call(depth0, "deleteBook", {hash:{},contexts:[depth0],types:["STRING"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push(">\n      Remove Book\n    </button>\n  </div>\n</article>");
  return buffer;
  
});

Ember.TEMPLATES["books"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
  var buffer = '', stack1, hashTypes, hashContexts, options, helperMissing=helpers.helperMissing, escapeExpression=this.escapeExpression, self=this;

function program1(depth0,data) {
  
  var buffer = '', stack1, stack2, hashContexts, hashTypes, options;
  data.buffer.push("\n      ");
  hashContexts = {'class': depth0};
  hashTypes = {'class': "ID"};
  options = {hash:{
    'class': ("list-group-item")
  },inverse:self.noop,fn:self.program(2, program2, data),contexts:[depth0,depth0],types:["STRING","ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data};
  stack2 = ((stack1 = helpers.linkTo || depth0.linkTo),stack1 ? stack1.call(depth0, "book", "book.id", options) : helperMissing.call(depth0, "linkTo", "book", "book.id", options));
  if(stack2 || stack2 === 0) { data.buffer.push(stack2); }
  data.buffer.push("\n    ");
  return buffer;
  }
function program2(depth0,data) {
  
  var buffer = '', stack1, hashTypes, hashContexts, options;
  data.buffer.push("\n        <span class=\"badge\">\n          ");
  hashTypes = {};
  hashContexts = {};
  options = {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data};
  data.buffer.push(escapeExpression(((stack1 = helpers.money || depth0.money),stack1 ? stack1.call(depth0, "book.currentPrice", options) : helperMissing.call(depth0, "money", "book.currentPrice", options))));
  data.buffer.push("\n          <span ");
  hashContexts = {'class': depth0};
  hashTypes = {'class': "STRING"};
  data.buffer.push(escapeExpression(helpers.bindAttr.call(depth0, {hash:{
    'class': (":glyphicon book.trend2glyph")
  },contexts:[],types:[],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("></span>\n        </span>\n        <h4 class=\"list-group-item-heading\">");
  hashContexts = {'length': depth0};
  hashTypes = {'length': "INTEGER"};
  options = {hash:{
    'length': (42)
  },contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data};
  data.buffer.push(escapeExpression(((stack1 = helpers.truncate || depth0.truncate),stack1 ? stack1.call(depth0, "book.title", options) : helperMissing.call(depth0, "truncate", "book.title", options))));
  data.buffer.push("</h4>\n        <p class=\"list-group-item-text\">");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers._triageMustache.call(depth0, "book.author", {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("</p>\n      ");
  return buffer;
  }

function program4(depth0,data) {
  
  
  data.buffer.push("\n      <div class=\"list-group-item\">\n        <h4 class=\"list-group-item-heading\">\n          No books.\n        </h4>\n        <p class=\"list-group-item-text text-muted\">\n          Add some or change filter. Or maybe it's just still loading.\n        </p>\n      </div>\n    ");
  }

  data.buffer.push("<div class=\"form-inline panel panel-default\">\n  <div class=\"form-group pull-right\">\n    <button class=\"btn btn-primary\" ");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers.action.call(depth0, "refreshBooks", {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push(">\n      Refresh\n    </button>\n  </div>\n  <form>\n    <div class=\"form-group\">\n      ");
  hashContexts = {'valueBinding': depth0,'class': depth0,'placeholder': depth0,'type': depth0,'required': depth0,'pattern': depth0};
  hashTypes = {'valueBinding': "STRING",'class': "STRING",'placeholder': "ID",'type': "STRING",'required': "STRING",'pattern': "STRING"};
  data.buffer.push(escapeExpression(helpers.view.call(depth0, "Ember.TextField", {hash:{
    'valueBinding': ("newISBN"),
    'class': ("form-control col-md-1"),
    'placeholder': ("ISBN"),
    'type': ("text"),
    'required': ("required"),
    'pattern': ("^((\\d{10})|(\\d{13}))$")
  },contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("\n    </div>\n    <button class=\"btn btn-success\" ");
  hashContexts = {'disabled': depth0};
  hashTypes = {'disabled': "STRING"};
  data.buffer.push(escapeExpression(helpers.bindAttr.call(depth0, {hash:{
    'disabled': ("newISBNInvalid")
  },contexts:[],types:[],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push(" ");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers.action.call(depth0, "addBook", "newISBN", {hash:{},contexts:[depth0,depth0],types:["ID","ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push(">\n      Add Book\n    </button>\n  </form>\n</div>\n\n<div class=\"row\">\n  <div class=\"col-md-4 books\">\n    <div class=\"panel panel-default\">\n      <div class=\"panel-heading\">\n        <h3 class=\"panel-title\">\n          Filter\n        </h3>\n      </div>\n      <div class=\"panel-body\">\n        <p class=\"input-group\">\n          <span class=\"input-group-addon\">Min. Value in ¢</span>\n          ");
  hashContexts = {'valueBinding': depth0,'class': depth0};
  hashTypes = {'valueBinding': "STRING",'class': "STRING"};
  data.buffer.push(escapeExpression(helpers.view.call(depth0, "Ember.TextField", {hash:{
    'valueBinding': ("minPrice"),
    'class': ("form-control")
  },contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("\n        </p>\n        <p class=\"input-group\">\n          <span class=\"input-group-addon\">Titel/Author</span>\n          ");
  hashContexts = {'valueBinding': depth0,'class': depth0};
  hashTypes = {'valueBinding': "STRING",'class': "STRING"};
  data.buffer.push(escapeExpression(helpers.view.call(depth0, "Ember.TextField", {hash:{
    'valueBinding': ("searchText"),
    'class': ("form-control")
  },contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("\n        </p>\n      </div>\n    </div>\n\n    <div class=\"list-group\">\n    ");
  hashTypes = {};
  hashContexts = {};
  stack1 = helpers.each.call(depth0, "book", "in", "filtered", {hash:{},inverse:self.program(4, program4, data),fn:self.program(1, program1, data),contexts:[depth0,depth0,depth0],types:["ID","ID","ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data});
  if(stack1 || stack1 === 0) { data.buffer.push(stack1); }
  data.buffer.push("\n\n      <div class=\"list-group-item\">\n        <p class=\"list-group-item-text text-right\">\n          <small class=\"text-muted\">TOTAL</small>\n          <strong class=\"text-success\">");
  hashTypes = {};
  hashContexts = {};
  options = {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data};
  data.buffer.push(escapeExpression(((stack1 = helpers.money || depth0.money),stack1 ? stack1.call(depth0, "priceSum", options) : helperMissing.call(depth0, "money", "priceSum", options))));
  data.buffer.push("</strong>\n        </p>\n      </div>\n    </div>\n  </div>\n  <div class=\"col-md-8\">\n    ");
  hashTypes = {};
  hashContexts = {};
  data.buffer.push(escapeExpression(helpers._triageMustache.call(depth0, "outlet", {hash:{},contexts:[depth0],types:["ID"],hashContexts:hashContexts,hashTypes:hashTypes,data:data})));
  data.buffer.push("\n  </div>\n</div>");
  return buffer;
  
});

Ember.TEMPLATES["books/index"] = Ember.Handlebars.template(function anonymous(Handlebars,depth0,helpers,partials,data) {
this.compilerInfo = [4,'>= 1.0.0'];
helpers = this.merge(helpers, Ember.Handlebars.helpers); data = data || {};
  


  data.buffer.push("<p class=\"alert alert-info\">\n  Please select a book on the left.\n</p>");
  
});