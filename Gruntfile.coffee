module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-commonjs')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-ember-templates')

  grunt.initConfig
    clean:
      all: [
        '.tmp/**/*.*'
        # 'public/css'
        # 'public/js'
      ]

    coffee:
      options:
        bare: true
      glob_to_multiple:
        expand: true
        cwd: ''
        src: ['client/**/*.coffee']
        dest: '.tmp/js'
        ext: '.js'

    copy:
      js:
        files: [{
          expand: true
          cwd: ''
          src: ['client/**/*.js']
          dest: '.tmp/js'
          ext: '.js'
        }]

    commonjs:
      modules:
        cwd: '.tmp/js/client/'
        src: '**/*.js'
        dest: '.tmp/js/client/'

    emberTemplates:
      compile:
        options:
          templateName: (sourceFile) ->
            sourceFile.replace(/client\/templates\//, '')
        files:
          'public/js/templates.js': ['client/templates/**/*.hbs']

    concat:
      precompile:
        src: [
          # 'vendor/jquery.js'
          'public/vendor/common.js'
          # 'vendor/handlebars.runtime.js'
          # 'vendor/ember.min.js'
          # 'vendor/ember-data.min.js'
          # '.tmp/js/client/templates.js'
          '.tmp/js/client/**/*.js'
        ]
        dest: 'public/js/app.js'

    uglify:
      precompile:
        files:
          'public/js/app.js': ['public/js/app.js']
          'public/js/templates.js': ['public/js/templates.js']

    watch:
      options:
        atBegin: true
        livereload: true
      js:
        files: 'client/**/*.js'
        tasks: ['copy:js', 'commonjs:modules', 'concat:precompile']
      coffee:
        files: 'client/**/*.coffee'
        tasks: ['coffee', 'commonjs:modules', 'concat:precompile']
      handlebars:
        files: 'client/**/*.hbs'
        tasks: ['emberTemplates']


  grunt.registerTask 'default', [
    'clean'
    'coffee'
    'copy'
    'commonjs:modules'
    'emberTemplates'
    'concat:precompile'
  ]

  grunt.registerTask 'precompile', [
    'clean'
    'coffee'
    'copy'
    'commonjs'
    'emberTemplates'
    'concat:precompile'
    'uglify'
  ]
