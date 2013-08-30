module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-commonjs')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-compress')
  grunt.loadNpmTasks('grunt-ember-templates')
  grunt.loadNpmTasks('grunt-recess')

  grunt.initConfig
    clean:
      all: [
        '.tmp/**/*.*'
        'public/css'
        'public/js'
        'public/fonts'
        'public/*.html'
      ]

    coffee:
      options:
        bare: true
      glob_to_multiple:
        expand: true
        cwd: 'client'
        src: ['app/**/*.coffee']
        dest: '.tmp/js'
        ext: '.js'

    copy:
      html:
        files: [{
          expand: true
          cwd: 'client'
          src: ['*.html']
          dest: 'public'
          ext: '.html'
        }]
      js:
        files: [{
          expand: true
          cwd: 'client'
          src: ['app/**/*.js']
          dest: '.tmp/js'
          ext: '.js'
        }]
      fonts:
        files: [{
          expand: true
          cwd: 'client'
          src: ['fonts/**/*']
          dest: 'public'
        }]

    commonjs:
      modules:
        cwd: '.tmp/js/app/'
        src: '**/*.js'
        dest: '.tmp/js/app/'

    emberTemplates:
      compile:
        options:
          templateName: (sourceFile) ->
            sourceFile.replace(/client\/app\/templates\//, '')
        files:
          'public/js/templates.js': ['client/app/templates/**/*.hbs']

    concat:
      precompile:
        src: [
          # 'vendor/jquery.js'
          'public/vendor/common.js'
          # 'vendor/handlebars.runtime.js'
          # 'vendor/ember.min.js'
          # 'vendor/ember-data.min.js'
          # '.tmp/js/client/templates.js'
          '.tmp/js/app/**/*.js'
        ]
        dest: 'public/js/app.js'

    uglify:
      precompile:
        files:
          'public/js/app.js': ['public/js/app.js']
          'public/js/templates.js': ['public/js/templates.js']

    recess:
      build:
        src: 'client/less/main.less'
        dest: 'public/css/style.css'
        options:
          compile: true
          compress: false
          noUnderscores: false
          noIDs: false
          zeroUnits: false
      compile:
        src: 'client/less/main.less'
        dest: 'public/css/style.css'
        options:
          compile: true
          compress: true
          noUnderscores: false
          noIDs: false
          zeroUnits: false

    compress:
      compile:
        options:
          mode: 'gzip'
          pretty: true
        expand: true
        cwd: 'public'
        src: ['js/**/*.js', 'css/**/*.css', 'fonts/**/*.svg', 'img/**/*.svg']
        dest: 'public'

    watch:
      options:
        atBegin: true
        livereload: true
      html:
        files: 'client/*.html'
        tasks: ['copy:html']
      fonts:
        files: 'client//fonts/**/*'
        tasks: ['copy:fonts']
      js:
        files: 'client/**/*.js'
        tasks: ['copy:js', 'commonjs:modules', 'concat:precompile']
      coffee:
        files: 'client/**/*.coffee'
        tasks: ['coffee', 'commonjs:modules', 'concat:precompile']
      handlebars:
        files: 'client/**/*.hbs'
        tasks: ['emberTemplates']
      less:
        files: 'public/**/*.less'
        tasks: ['recess:build']


  grunt.registerTask 'default', [
    'clean'
    'coffee'
    'copy'
    'commonjs:modules'
    'emberTemplates'
    'concat:precompile'
    'recess:build'
  ]

  grunt.registerTask 'precompile', [
    'clean'
    'coffee'
    'copy'
    'commonjs'
    'emberTemplates'
    'concat:precompile'
    'uglify'
    'recess:compile'
    'compress:compile'
  ]
