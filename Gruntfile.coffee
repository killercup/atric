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
  grunt.loadNpmTasks('grunt-template')

  userConfig = require "#{__dirname}/client/build.config"
  pkg = grunt.file.readJSON('package.json')

  grunt.initConfig
    pkg: pkg

    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>\n'+
      '* Many thanks to all those who made this possible by contributing to open source software!'+
      '*/\n'

    clean:
      all: [
        '.tmp'
        'public'
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
      favicons:
        files: [{
          expand: true
          cwd: 'client/favicons'
          src: ['*.png', '*.ico']
          dest: 'public'
        }]
      js:
        files: [{
          expand: true
          cwd: 'client'
          src: ['app/**/*.js']
          dest: '.tmp/js'
          ext: '.js'
        }]
      vendor:
        files: [{
          expand: true
          # flatten: true
          cwd: 'client'
          src: userConfig.getLocalFiles('development', userConfig.vendor)
          dest: 'public'
        }]
      vendor_min:
        files: [{
          expand: true
          # flatten: true
          cwd: 'client'
          src: userConfig.getLocalFiles('production', userConfig.vendor)
          dest: 'public'
        }]
      fonts:
        files: [{
          expand: true
          cwd: 'client'
          src: ['fonts/**/*']
          dest: 'public'
        }]

    template:
      build:
        options:
          data:
            vendor_js: userConfig.getSpecificEnv('development', userConfig.vendor)
            cachebuster: "?#{+(new Date())}"
            pkg: pkg
            production: false
            footer: grunt.file.read('client/_footer.tpl')
        files: [{
          expand: true
          cwd: 'client'
          src: ['*.html']
          dest: 'public'
          ext: '.html'
        }]
      precompile:
        options:
          data:
            vendor_js: userConfig.getSpecificEnv('production', userConfig.vendor)
            cachebuster: "?#{+(new Date())}"
            pkg: pkg
            production: true
            footer: grunt.file.read('client/_footer.tpl')
        files: [{
          expand: true
          cwd: 'client'
          src: ['*.html']
          dest: 'public'
          ext: '.html'
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
            sourceFile.replace(/^client\/app\/(\w+)\//, '')
        files:
          'public/js/templates.js': ['client/app/**/*.hbs']

    concat:
      precompile:
        src: userConfig.getLocalFiles('development', userConfig.app, 'client/').concat [
          '.tmp/js/app/**/*.js'
        ]
        dest: 'public/js/app.js'

    uglify:
      options:
        banner: '<%= banner %>'
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
        src: ['**/*.js', 'css/**/*.css', 'fonts/**/*.svg', 'img/**/*.svg']
        dest: 'public'

    watch:
      options:
        atBegin: true
        livereload: true
      buildConfig:
        files: 'client/build.config.coffee'
        tasks: ['copy:vendor', 'template:build']
      html:
        files: ['client/*.html', 'client/*.tpl']
        tasks: ['template:build']
      fonts:
        files: 'client/fonts/**/*'
        tasks: ['copy:fonts']
      images:
        files: 'client/favicons/**/*'
        tasks: ['copy:favicons']
      js:
        files: ['client/app/**/*.js']
        tasks: ['copy:js', 'commonjs:modules', 'concat:precompile']
      coffee:
        files: 'client/app/**/*.coffee'
        tasks: ['coffee', 'commonjs:modules', 'concat:precompile']
      handlebars:
        files: 'client/app/**/*.hbs'
        tasks: ['emberTemplates']
      less:
        files: 'client/less/**/*.less'
        tasks: ['recess:build']


  grunt.registerTask 'default', [
    'clean'
    'coffee'
    'copy:fonts'
    'copy:favicons'
    'copy:js'
    'copy:vendor'
    'template:build'
    'commonjs:modules'
    'emberTemplates'
    'concat:precompile'
    'recess:build'
  ]

  grunt.registerTask 'precompile', [
    'clean'
    'coffee'
    'copy:fonts'
    'copy:favicons'
    'copy:js'
    'copy:vendor_min'
    'template:precompile'
    'commonjs'
    'emberTemplates'
    'concat:precompile'
    'uglify'
    'recess:compile'
    'compress:compile'
  ]
