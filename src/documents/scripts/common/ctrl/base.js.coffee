'use strict'

###
Common controllers
###

angular.module('common.ctrl', [])
.controller 'BaseCtrl', [ '$rootScope', '$scope', '$log'
($rootScope, $scope, $log) ->
    $log.info ("Base Ctrl loaded")

    $scope.init = () ->
        $log.log ("Base Ctrl init")
        return false
]
