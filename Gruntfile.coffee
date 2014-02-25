module.exports = (grunt) ->
  "use strict"
  grunt.initConfig
    clean:
      build: ["build"]

    copy:
      static:
        files: [
          expand: true
          cwd: "source"
          matchBase: true
          src: ["*.*", "!*.styl", "!*.haml", "!*.coffee", "!*.jpg", "!*.jpeg", "!*.png"]
          dest: "build"
          filter: "isFile"
        ]

    parallel:
      server:
        tasks: ["watch", "connect:server"]
        options:
          grunt: true
          stream: true

    connect:
      server:
        options:
          port: 5678
          base: "build"
          keepalive: true

    watch:
      coffee:
        files: ["source/**/*.coffee"]
        tasks: ["coffee", "uglify"]
        options:
          livereload: true

      stylus:
        files: ["source/**/*.styl"]
        tasks: ["stylus", "autoprefixer", "cssmin"]
        options:
          livereload: true

      haml_html:
        files: ["source/**/*.haml", "!source/templates/**/*.haml"]
        tasks: ["haml:html"]
        options:
          livereload: true

      haml_templates:
        files: ["source/templates/**/*.haml"]
        tasks: ["haml:templates"]
        options:
          livereload: true

      imagemin:
        files: ["source/**/*.jpg", "source/**/*.jpeg", "source/**/*.png"]
        tasks: ["imagemin"]
        options:
          livereload: true

    imagemin:
      options:
        optimizationLevel: 0
        progressive: true

      compile:
        files: [
          expand: true
          cwd: "source"
          matchBase: true
          src: ["*.jpg", "*.jpeg", "*.png"]
          dest: "build"
        ]

    coffee:
      compile:
        files: [
          expand: true
          cwd: "source"
          matchBase: true
          src: ["*.coffee"]
          dest: "build"
          ext: ".js"
        ]

    stylus:
      options:
        urlfunc: "embedurl"
      compile:
        files: [
          expand: true
          cwd: "source"
          matchBase: true
          src: ["*.styl"]
          dest: "build"
          ext: ".css"
        ]

    autoprefixer:
      options:
        browsers: ["last 3 versions"]

      compile:
        files: [
          expand: true
          matchBase: true
          cwd: "build"
          src: "*.css"
          dest: "build"
        ]

    haml:
      html:
        files: [
          expand: true
          cwd: "source"
          matchBase: true
          src: ["*.haml", "!templates/**/*.haml"]
          dest: "build"
          ext: ".html"
        ]
        options:
          target: "html"
          language: "coffee"

      templates:
        files: [
          expand: true
          cwd: "source/templates"
          matchBase: true
          src: "*.haml"
          dest: "build/templates"
          ext: ".js"
        ]
        options:
          target: "js"
          language: "coffee"
          namespace: "window.templates"
          bare: false

    cssmin:
      compile:
        files:
          "build/bundle.min.css": [
            "build/main.css"
          ]

    uglify:
      bundle:
        options:
          preserveComments: "some"
        files:
          "build/bundle.min.js": [
            "build/mandrill.js"
            "source/jquery.ba-throttle-debounce.js"
            "build/main.js"
          ]

  require("fs").readdirSync("node_modules").forEach (name) ->
    grunt.loadNpmTasks name  if /^grunt-/.test(name)

  grunt.registerTask "server", ["parallel:server"]
  grunt.registerTask "build", ["copy", "imagemin", "stylus", "autoprefixer", "coffee", "haml", "uglify", "cssmin"]
  grunt.registerTask "default", ["clean", "build", "server"]
