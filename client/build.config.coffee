###
# Vendor Files build config

- `files.app` are references to files that will be concatenated into `app.js`.
- `files.vendor` are references to local files and CDN links to the same files.

For each file reference, different environments can be specified (usually
'development' and 'production').

CDN files will be included with a fallback to the local file, so you should
always include one. To check whether a CDN file has been loaded, a global
variable will be tested. If it doesn't exist, the local file will be included.
By default, the key of the reference is used as global name, but you can
overwrite it by setting a `global` key in the environment.

To load the vendor files correctly, include something like the following in
your HTML:

    <% _.each(vendor_js, function (paths, name) { %><% if (paths.cdn) { %>
      <script src="<%= paths.cdn %>"></script>
      <script>window.<%= paths.global || name %> || document.write('<script src="<%= paths.local %>"><\/script>')</script>
    <% } else { %>
      <script src="<%= paths.local %>"></script>
    <% } }); %>

###

bower = "vendor"

files =
  app:
    commonjs:
      development:
        local: "#{bower}/commonjs/common.js"
      production:
        local: "#{bower}/commonjs/common.js"

  vendor:
    'jQuery':
      development:
        local: "#{bower}/jquery/jquery.js"
        cdn: "//cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.js"
      production:
        local: "#{bower}/jquery/jquery.min.js"
        cdn: "//cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min.js"
    'Handlebars':
      development:
        local: "#{bower}/handlebars/handlebars.js"
        cdn: "//cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.0.0/handlebars.js"
      production:
        local: "#{bower}/handlebars/handlebars.js"
        cdn: "//cdnjs.cloudflare.com/ajax/libs/handlebars.js/1.0.0/handlebars.min.js"
    'Ember':
      development:
        local: "#{bower}/ember/ember.js"
        cdn: "//cdnjs.cloudflare.com/ajax/libs/ember.js/1.0.0/ember.js"
      production:
        local: "#{bower}/ember/ember.min.js"
        cdn: "//cdnjs.cloudflare.com/ajax/libs/ember.js/1.0.0/ember.min.js"
    'ember-data':
      development:
        global: 'DS'
        local: "#{bower}/ember-data/index.js"
      production:
        global: 'DS'
        local: "#{bower}/ember-data-min/index.js"
    'd3':
      development:
        local: "#{bower}/d3/d3.js"
        cdn: "//cdnjs.cloudflare.com/ajax/libs/d3/3.2.2/d3.v3.js"
      production:
        local: "#{bower}/d3/d3.min.js"
        cdn: "//cdnjs.cloudflare.com/ajax/libs/d3/3.2.2/d3.v3.min.js"
    'bootstrap':
      development:
        local: "#{bower}/bootstrap/dist/js/bootstrap.js"
      production:
        local: "#{bower}/bootstrap/dist/js/bootstrap.min.js"

getSpecificEnv = (env='development', list=files.vendor) ->
  result = {}
  for key, value of list
    result[key] = value[env] if value?[env]?
  return result

getLocalFiles = (env='development', list=files.app, prefix='') ->
  result = []
  for key, value of list
    result.push(prefix + value[env].local) if value?[env]?.local?
  return result

module.exports =
  app: files.app
  vendor: files.vendor
  getSpecificEnv: getSpecificEnv
  getLocalFiles: getLocalFiles
