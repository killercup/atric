bower = "vendor"

files =
  app:
    commonjs:
      development:
        local: "#{bower}/commonjs/commonjs.js"
      production:
        local: "#{bower}/commonjs/commonjs.js"

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
        cdn: "//cdnjs.cloudflare.com/ajax/libs/ember.js/1.0.0-rc.8/ember.js"
      production:
        local: "#{bower}/ember/ember.min.js"
        cdn: "//cdnjs.cloudflare.com/ajax/libs/ember.js/1.0.0-rc.8/ember.min.js"
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

getSpecificEnv = (env='development', list=files.vendor) ->
  result = {}
  for key, value of list
    result[key] = value[env] if value?[env]?
  return result

getLocalFiles = (env='development', list=files.app) ->
  result = []
  for key, value of list
    result.push value[env].local if value?[env]?.local?
  return result

module.exports =
  app: files.app
  vendor: files.vendor
  getSpecificEnv: getSpecificEnv
  getLocalFiles: getLocalFiles
