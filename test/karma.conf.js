// Start these browsers, currently available:
// - Chrome
// - ChromeCanary
// - Firefox
// - Opera
// - Safari (only Mac)
// - PhantomJS
// - IE (only Windows)

//'karma-mocha'


// 'out/js/vendor/lodash.js',
// 'out/js/vendor/modernizr-2.6.2-respond-1.1.0.min.js',
// 'out/js/vendor/placeholders.js',
// 'out/js/vendor/raf.js',
// 'out/js/vendor/selectivizr-1.0.2.min.js',
// 'out/scripts/**/*.js',

module.exports = function(config){
    config.set({
    basePath : '../',

    files : [
      'test/lib/jquery-2.0.3.min.js',
      'out/js/vendor/angular/angular.js',
      'out/js/vendor/angular/angular-*.js',
      'test/lib/angular-mocks.js',
      'out/scripts/all.min.js',
      'test/unit/**/*.js'
    ],

    exclude : [
      'out/js/vendor/angular/*.min.js'
    ],

    autoWatch : true,

    frameworks: ['jasmine'],

    browsers : ['Chrome'],

    plugins : [
            'karma-junit-reporter',
            'karma-chrome-launcher',
            'karma-firefox-launcher',
            'karma-jasmine',
            'karma-osx-reporter'
            ],

    reporters: ['progress', 'osx'],

    junitReporter : {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    }

})}
