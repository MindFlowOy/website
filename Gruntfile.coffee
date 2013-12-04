module.exports = (grunt) ->
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    gruntConfig = grunt.file.readJSON("./grunt-config.json")
    grunt.registerTask "default", ['cssmin', 'concat', 'uglify']
    grunt.initConfig gruntConfig
