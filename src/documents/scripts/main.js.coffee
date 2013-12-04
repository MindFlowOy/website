'use strict'

###
Main module config & run
###

main = angular.module 'main', [ 'ngRoute', 'common.ctrl','common.drctv']

main.config [ '$locationProvider', '$routeProvider',
($locationProvider, $routeProvider) ->
    #reloadOnSearch=true
    #templateUrl: 'chapter.html'
    #controller: ChapterCntl
    $routeProvider
    .when('/',
    template: (routeParams, curentPath)->
        debugger
        return '/'
    )
    .otherwise(
        redirectTo: '/'
    )
    $locationProvider.html5Mode(true).hashPrefix('!')
]

main.run ['$window', '$document', '$rootScope', '$log', '$q', '$location',
($window, $document, $rootScope, $log, $q, $location) ->
    $rootScope.$on '$routeChangeStart', (newRoute, oldRoute)->
        $log.info '$routeChangeStart'
    $rootScope.$on '$routeUpdate', (newRoute, oldRoute)->
        $log.info '$routeUpdate'
    $rootScope.$on '$routeChangeSuccess', (newRoute, oldRoute)->
        $log.info '$routeChangeSuccess!!'
        $location.hash $routeParams.scrollTo
        $anchorScroll()


    ###
    * Wrapper for angular.isArray, isObject, etc checks for use in the view by isArray(array),
    * isObject(object) etc (and from code: $scope.isArray())
    *
    * @method isArray, isObject...
    * @param type {string} the name of the check (casing sensitive)
    * @param value {string} value to check
    * @api public
    ###
    $rootScope.is = (type, value) ->
        angular["is" + type] value


    ###
    * Log debugging tool
    *
    * Allows you to execute log functions from the view by log() (and from code: $scope.log())
    * @method log
    * @param value {mixed} value to be logged
    * @api public
    ###
    $rootScope.log = (variable) ->
        console.log variable if console?.log

    ###
    * alert debugging tool
    *
    * Allows you to execute alert functions from the view by alert() ( and from code: $scope.alert())
    * @method alert
    * @param {string} text - text to be alerted
    * @api public
    ###
    $rootScope.alert = (text, needsTranslation) ->
        alert text
]
