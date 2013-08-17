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
          'public/js/app.js': ['public/**/*.coffee']

    watch:
      app:
        files: 'src/**/*.coffee'
        tasks: 'coffee:compile'
        options:
          atBegin: true
          # spawn: false
          # interrupt: true

  grunt.registerTask('default', ['coffee:compile'])