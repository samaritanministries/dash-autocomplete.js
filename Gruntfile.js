'use strict';

module.exports = function (grunt) {
  require('load-grunt-tasks')(grunt);
  grunt.initConfig({
    //********************************
    //Tasks in alphabetical order
    //********************************

    clean: {
      tmp: ['.tmp/*'],
      dist: ['dist/*']
    },

    coffee: {
      src: {
        files: [{
          expand: true,
          cwd: 'scripts',
          src: '**/**/*.coffee',
          dest: '.tmp/scripts',
          ext: '.js'
        }]
      },

      spec: {
        files: [{
          expand: true,
          cwd: 'spec',
          src: '**/**/*.coffee',
          dest: '.tmp/spec',
          ext: '.js'
        }]
      }
    },

    copy: {
      namespace: {
        src: 'scripts/namespace.js',
        dest: '.tmp/scripts/namespace.js'
      },
      css: {
        src: '.tmp/styles/dash-autocomplete.css',
        dest: 'dist/dash-autocomplete.css'
      },
      scss: {
        src: 'styles/dash-autocomplete.scss',
        dest: 'dist/dash-autocomplete.scss'
      }
    },

    connect: {
      demo: {
        options: {
          protocol: 'https',
          keepalive: true,
          open: 'https://localhost:8000/demo'
        },
      }
    },

    jst: {
      compile: {
        options: {
          namespace: 'DashAutocompleteJST'
        },
        files: {
          ".tmp/scripts/dash-autocomplete/templates.js": ["scripts/dash-autocomplete/**/*.ejs"]
        }
      }
    },

    sass: {
      dist: {
        files: {
          ".tmp/styles/dash-autocomplete.css": "styles/dash-autocomplete.scss"
        }
      }
    },

    uglify: {
      options: {
        mangle: true
      },

      dist: {
        files: {
          'dist/dash-autocomplete.min.js': [
            '.tmp/scripts/namespace.js',
            '.tmp/scripts/dash-autocomplete/templates.js',
            '.tmp/scripts/dash-autocomplete/view.js'
          ]
        }
      }
    },
  });

  //********************************
  //Builds
  //********************************

  grunt.registerTask('build:dist', [
                     'clean',
                     'jst',
                     'coffee:src',
                     'sass',
                     'copy:namespace',
                     'copy:css',
                     'copy:scss',
                     'uglify'

  ]);

  grunt.registerTask('build:demo', [
                     'clean:tmp',
                     'clean:dist',
                     'jst',
                     'coffee:src',
                     'sass',
                     'copy:namespace',
                     'copy:css',
                     'copy:scss',
                     'connect:demo'

  ]);

  grunt.registerTask('build:spec', [
                     'clean:tmp',
                     'jst',
                     'coffee:src',
                     'coffee:spec'
  ]);

  grunt.registerTask('default', ['build:dist']);
};
