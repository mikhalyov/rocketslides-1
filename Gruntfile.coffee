module.exports = (grunt) ->
  "use strict"
  grunt.initConfig
    clean:
      build: ["../rocketslides-html"]

    copy:
      static:
        files: [
          expand: true
          cwd: "source"
          matchBase: true
          src: ["*.*", "!*.styl", "!*.haml", "!*.coffee", "!*.jpg", "!*.jpeg", "!*.png"]
          dest: "../rocketslides-html"
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
          base: "../rocketslides-html"
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
          dest: "../rocketslides-html"
        ]

    coffee:
      compile:
        files: [
          expand: true
          cwd: "source"
          matchBase: true
          src: ["*.coffee"]
          dest: "../rocketslides-html"
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
          dest: "../rocketslides-html"
          ext: ".css"
        ]

    autoprefixer:
      options:
        browsers: ["last 3 versions"]

      compile:
        files: [
          expand: true
          matchBase: true
          cwd: "../rocketslides-html"
          src: "*.css"
          dest: "../rocketslides-html"
        ]

    haml:
      html:
        files: [
          expand: true
          cwd: "source"
          matchBase: true
          src: ["*.haml", "!templates/**/*.haml"]
          dest: "../rocketslides-html"
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
          dest: "../rocketslides-html/templates"
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
          "../rocketslides-html/bundle.min.css": [
            "../rocketslides-html/main.css"
          ]

    uglify:
      bundle:
        options:
          preserveComments: "some"
        files:
          "../rocketslides-html/bundle.min.js": [
            "../rocketslides-html/mandrill.js"
            "source/jquery.ba-throttle-debounce.js"
            "../rocketslides-html/main.js"
          ]

  require("fs").readdirSync("node_modules").forEach (name) ->
    grunt.loadNpmTasks name  if /^grunt-/.test(name)

  grunt.registerTask "server", ["parallel:server"]
  grunt.registerTask "../rocketslides-html", ["copy", "imagemin", "stylus", "autoprefixer", "coffee", "haml", "uglify", "cssmin"]
  grunt.registerTask "default", ["../rocketslides-html", "server"]
