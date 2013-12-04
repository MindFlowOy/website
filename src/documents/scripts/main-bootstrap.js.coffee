'use strict'

###
Angular bootsrapper
###

# Called when all modules are loaded
angular.element(window.document).ready ->
    angular.bootstrap(document, ['main'])

    try
        body = window.document.getElementsByTagName('body')?[0]
        # Not sure should we set this - it was required for karma e2e
        # but not sure how about protractor
        # angular.element(body).attr('ng-app', 'test') if body
    catch e
        console.info "Angular bootsrap error #{e}" if console?.info

  console.info "Angular bootsrapped" if console?.info
