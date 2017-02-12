###jshint node:true###

'use strict'
# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# If you want to recursively match all subfolders, use:
# 'test/spec/**/*.js'

module.exports = (grunt) ->
  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt') grunt
  # Automatically load required grunt tasks
  require('jit-grunt') grunt, useminPrepare: 'grunt-usemin'
  # Configurable paths
  config = 
    app: 'app'
    dist: 'dist'

  # Load the core LESS tasks
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-pug'

  # Define the configuration for all the tasks
  grunt.initConfig
    config: config
    watch:
      bower:
        files: [ 'bower.json' ]
        tasks: [ 'wiredep' ]
      js:
        files: [ '<%= config.app %>/scripts/{,*/}*.js' ]
        tasks: [ 'jshint' ]
      jstest:
        files: [ 'test/spec/{,*/}*.js' ]
        tasks: [ 'test:watch' ]
      gruntfile: files: [ 'Gruntfile.coffee' ]
      less:
        files: [ '<%= config.app %>/styles/{,*/}*.less' ]
        tasks: [
          'less:server'
          'postcss'
        ]
      jade:
        files: [ '<%= config.app %>{,*/}*.jade' ]
        tasks: [
          'jade:server'
        ]
      styles:
        files: [ '<%= config.app %>/styles/{,*/}*.css' ]
        tasks: [
          'newer:copy:styles'
          'postcss'
        ]

    browserSync:
      options:
        notify: false
        background: true
      livereload: options:
        files: [
          '<%= config.app %>/{,*/}*.html'
          '.tmp/styles/{,*/}*.css'
          '.tmp/{,*/}*.html'
          '<%= config.app %>/images/{,*/}*'
          '<%= config.app %>/scripts/{,*/}*.js'
          '/scripts/{,*/}*.js'
          'bower_components/bootstrap-less/fonts/*'
        ]
        port: 9000
        server:
          baseDir: [
            '.tmp'
            config.app
          ]
          routes: 
            '/bower_components': './bower_components'
            '/styles/fonts': './bower_components/bootstrap-less/fonts'

      test: options:
        port: 9001
        open: false
        logLevel: 'silent'
        host: 'localhost'
        server:
          baseDir: [
            '.tmp'
            './test'
            config.app
          ]
          routes: '/bower_components': './bower_components'

      dist: options:
        background: false
        server: '<%= config.dist %>'

    clean:
      dist: files: [ {
        dot: true
        src: [
          '.tmp'
          '<%= config.dist %>/*'
          '!<%= config.dist %>/.git*'
        ]
      } ]
      server: '.tmp'

    jshint:
      options:
        jshintrc: '.jshintrc'
        reporter: require('jshint-stylish')
      all: [
        'Gruntfile.js'
        '<%= config.app %>/scripts/{,*/}*.js'
        '!<%= config.app %>/scripts/vendor/*'
        'test/spec/{,*/}*.js'
      ]

    mocha: all: options:
      run: true
      urls: [ 'http://<%= browserSync.test.options.host %>:<%= browserSync.test.options.port %>/index.html' ]

    ###
      ANDRE: Added this section for less.
    ###
    less:
      options:
        sourceMap: true
        sourceMapEmbed: true
        sourceMapContents: true
        includePaths: [ 'bower_components/bootstrap-less' ]

      server: 
        files: [ 
          expand: true
          cwd: '<%= config.app %>/styles'
          src: [ '*.less' ]
          dest: '.tmp/styles'
          ext: '.css'
        ]

      dist: 
        options: 
          compress: true
          plugins: [
            new (require('less-plugin-autoprefix'))({browsers: ["last 2 versions"]})
            new (require('less-plugin-clean-css'))()
          ]
        files: [ {
          expand: true
          cwd: '<%= config.app %>/styles'
          src: [ '*.less' ]
          dest: '.tmp/styles'
          ext: '.css'
        } ]

    ###
      ANDRE: Added this section for jade.
    ###
    jade:
      options:
        sourceMap: true
        sourceMapEmbed: true
        sourceMapContents: true
        pretty: true
        

      server: 
        options: 
          data:
            debug: false
        files: [ 
          expand: true
          cwd: '<%= config.app %>'
          src: [ '{,*/}*.jade' ]
          dest: '.tmp'
          ext: '.html'
        ]

      dist: 
        options: 
          pretty: false
          data:
            debug: false

        files: [ {
          expand: true
          cwd: '<%= config.app %>'
          src: [ '{,*/}*.jade' ]
          dest: '<%= config.dist %>'
          ext: '.html'
        } ]

    postcss:
      options:
        map: true
        processors: [ require('autoprefixer-core')(browsers: [
          '> 1%'
          'last 2 versions'
          'Firefox ESR'
          'Opera 12.1'
        ]) ]
      dist: files: [ {
        expand: true
        cwd: '.tmp/styles/'
        src: '{,*/}*.css'
        dest: '.tmp/styles/'
      } ]
    wiredep:
      app:
        src: [ '<%= config.app %>/index.html' ]
        exclude: [ 'bootstrap.js' ]
        ignorePath: /^<%= config.app %>\/|\.\.\//
      less:
        src: [ '<%= config.app %>/styles/{,*/}*.{less}' ]
        ignorePath: /(\.\.\/){1,2}bower_components\//
    filerev: dist: src: [
      '<%= config.dist %>/scripts/{,*/}*.js'
      '<%= config.dist %>/styles/{,*/}*.css'
      '<%= config.dist %>/images/{,*/}*.*'
      '<%= config.dist %>/styles/fonts/{,*/}*.*'
      '<%= config.dist %>/*.{ico,png}'
    ]
    useminPrepare:
      options: dest: '<%= config.dist %>'
      html: '<%= config.app %>/index.html'
    usemin:
      options: assetsDirs: [
        '<%= config.dist %>'
        '<%= config.dist %>/images'
        '<%= config.dist %>/styles'
      ]
      html: [ '<%= config.dist %>/{,*/}*.html' ]
      css: [ '<%= config.dist %>/styles/{,*/}*.css' ]
    imagemin: dist: files: [ {
      expand: true
      cwd: '<%= config.app %>/images'
      src: '{,*/}*.{gif,jpeg,jpg,png}'
      dest: '<%= config.dist %>/images'
    } ]
    svgmin: dist: files: [ {
      expand: true
      cwd: '<%= config.app %>/images'
      src: '{,*/}*.svg'
      dest: '<%= config.dist %>/images'
    } ]
    htmlmin: dist:
      options:
        collapseBooleanAttributes: true
        collapseWhitespace: true
        conservativeCollapse: true
        removeAttributeQuotes: true
        removeCommentsFromCDATA: true
        removeEmptyAttributes: true
        removeOptionalTags: true
        removeRedundantAttributes: false
        useShortDoctype: true
      files: [ {
        expand: true
        cwd: '<%= config.dist %>'
        src: '{,*/}*.html'
        dest: '<%= config.dist %>'
      } ]
    copy: dist: files: [
      {
        expand: true
        dot: true
        cwd: '<%= config.app %>'
        dest: '<%= config.dist %>'
        src: [
          '*.{ico,png,txt}'
          'images/{,*/}*.webp'
          '{,*/}*.html'
          'styles/fonts/{,*/}*.*'
        ]
      }
      {
        expand: true
        dot: true
        cwd: 'bower_components/bootstrap-less/fonts/'
        src: '*'
        dest: '<%= config.dist %>/styles/fonts'
      }
    ]
    modernizr: dist:
      devFile: 'bower_components/modernizr/modernizr.js'
      outputFile: '<%= config.dist %>/scripts/vendor/modernizr.js'
      files: src: [
        '<%= config.dist %>/scripts/{,*/}*.js'
        '<%= config.dist %>/styles/{,*/}*.css'
        '!<%= config.dist %>/scripts/vendor/*'
      ]
      uglify: true
    concurrent:
      server: [ 'less:server', 'jade:server' ]
      test: []
      dist: [
        'less'
        'jade'
        'imagemin'
        'svgmin'
      ]

  grunt.registerTask 'serve', 'start the server and preview your app', (target) ->
    if target == 'dist'
      return grunt.task.run([
        'build'
        'browserSync:dist'
      ])
    grunt.task.run [
      'clean:server'
      'wiredep'
      'concurrent:server'
      'postcss'
      'browserSync:livereload'
      'watch'
    ]
    return

  grunt.registerTask 'server', (target) ->
    grunt.log.warn 'The `server` task has been deprecated. Use `grunt serve` to start a server.'
    grunt.task.run [ if target then 'serve:' + target else 'serve' ]
    return

  grunt.registerTask 'test', (target) ->
    if target != 'watch'
      grunt.task.run [
        'clean:server'
        'concurrent:test'
        'postcss'
      ]
    grunt.task.run [
      'browserSync:test'
      'mocha'
    ]
    return

  grunt.registerTask 'build', [
    'clean:dist'
    'wiredep'
    'useminPrepare'
    'concurrent:dist'
    'postcss'
    'concat'
    'cssmin'
    'uglify'
    'copy:dist'
    'modernizr'
    'filerev'
    'usemin'
    'htmlmin'
  ]

  grunt.registerTask 'default', [
    'newer:jshint'
    'test'
    'build'
  ]
  return

