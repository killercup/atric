module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.initConfig
    coffee:
      compile:
        options:
          sourceMap: true
          join: true
        files:
          'public/js/app.js': ['public/app/**/*.coffee']
    watch:
      options:
        atBegin: true
        livereload: false
      app:
        files: ['src/app/**/*.coffee']
        tasks: 'coffee:compile'

  grunt.registerTask('default', ['coffee:compile'])