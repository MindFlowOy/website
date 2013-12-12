'use strict'

###
* AngularJS directives to navigation and smooth scrollin based on menu selection and scroll position
* Usage:
* <body data-mf-spy-scroll-to='true'>
*    <nav>
*        <a mf-scroll-to='id1' [offset='value']>...</a>
*        <a mf-scroll-to='id2' [offset='value']>...</a>
*     </nav>
* </body>
* Inspired by: http://www.itnewb.com/tutorial/Creating-the-Smooth-Scroll-Effect-with-JavaScript
###

mdl = angular.module('common.drctv', [])


#----- common service


###
* Directives' helper service to store scorll anchors for updating nav menu based on scroll position.
* Conatins also many helper classes for easy scrolling - not sure what would be best palce for them if not here
* Inspired by: https://github.com/patrickmarabeas/ng-ScrollSpy.js
###
mdl.service 'scrollToService', ['$window', '$log'
($window, $log) ->

    navItems: []

    #Animation frame does this many iterations when scrolling from position 1 to 2
    EASY_ITERATIONS: 60

    # up/down
    DIRECTIONS:
        NEXT: 'next'
        PREV: 'prev'

    ###
    * Add navigation items saved ones
    * @param {Object.<element, string>} nav - Object to be saved for later use by directives, contains nav element and target anchor id values
    ###
    addNavItem: (nav) ->
        if nav?.anchor and nav?.element
            #don't add dublicates - only on element per anchor is enough
            alreadyThere = false
            alreadyThere = true for item in @navItems when item.anchor is nav.anchor
            unless alreadyThere
                # TODO: how to set some meaningful offset?
                # Calculate nav item position
                nav.position = @elmYPosition(nav.anchor) - 200
                #$log.info 'Adding anchor ', nav
                @navItems.push nav

    ###
    * Helper to get the current vertical position of the given DOM element
    * @param {string} eID - The DOM element id
    * @returns The vertical position of element with id eID
    ###
    elmYPosition: (eID) ->
      elm = document.getElementById(eID)
      if elm
        y = elm.offsetTop
        node = elm
        while node.offsetParent and node.offsetParent isnt document.body
          node = node.offsetParent
          y += node.offsetTop
        return y
      0


    ###
    * Helper to get linear easing values when direction, target and current position is known
    * @param {string}  direction
    * @param {number}  target position
    * @param {number}  current position
    * @returns {Array.<number>}  - Easign values
    ###
    calculateEasyVals: (direction, target, position)->
        easyVals = []
        iteration = 0
        if direction is @DIRECTIONS.NEXT
            lastVal = position
            while lastVal < target
                iteration++
                spaceToIterate = target - position
                iterationStep = Math.round(spaceToIterate / @EASY_ITERATIONS)
                easyVal = position + iteration * iterationStep
                if easyVal > target
                    easyVal = target
                lastVal = easyVal
                easyVal = 0 if easyVal < 0
                easyVals.push easyVal
        else if direction is @DIRECTIONS.PREV
            lastVal = position
            while lastVal > target
                iteration++
                spaceToIterate =  position - target
                iterationStep = Math.round(spaceToIterate / @EASY_ITERATIONS)
                easyVal = position - iteration * iterationStep
                lastVal = easyVal
                if easyVal < target
                    easyVal = target
                easyVal = 0 if easyVal < 0
                easyVals.push easyVal

        return easyVals

    ###
    * Scroll to the element with given easing positions by using Animation Frames
    * @param {element} el - The element where to scroll to
    * @param {Array.<number>}  easing - Easign values
    * @param {number}  iteration - Current animation iteration
    ###
    easyScrollTo: (el, easing, iteration) ->
        if iteration < easing.length
            # do the scrolling itself
            $window.scrollTo(0, easing[iteration])
            iteration++
            repeatScrollTo = angular.bind @, @easyScrollTo, el, easing, iteration
            requestAnimationFrame repeatScrollTo
        else


    ###
    * Scroll to element with a specific ID and offset
    * @param {element} el - The element where to scroll to
    * @param {number} offSet - Scrolling offset (meaning how much earlier of the element postion scrolling should be stopped)
    ###
    scrollToElWithOffset: (el, offSet) ->

        startY = @currentYPosition()
        stopY = @elmYPosition(el) - offSet

        direction = @DIRECTIONS.NEXT
        if stopY < startY
            direction = @DIRECTIONS.PREV

        easingVals = @calculateEasyVals direction, stopY, startY
        @easyScrollTo el, easingVals, 0
        return

    ###
    * Helper to retrieve the current vertical position
    * @returns {number} Current vertical position
    ###
    currentYPosition: ->
      # Firefox, Chrome, Opera, Safari
      return $window.pageYOffset  if $window.pageYOffset

      # Internet Explorer 6 - standards mode
      return $window.document.documentElement.scrollTop  if $window.document.documentElement and $window.document.documentElement.scrollTop

      # Internet Explorer 6, 7 and 8
      return $window.document.body.scrollTop  if $window.document.body.scrollTop
      0
]


#-----


###
* Scroll position directive to show correct navigation item when users are scrolling the page
###
mdl.directive 'mfSpyScrollTo', ['$log', 'scrollToService', '$interval',
($log, scrollToService, $interval)->

    restrict: "A"
    controller: [ "$scope", ($scope) ->
            @scrollToService = scrollToService
    ]
    link: (scope, element, attrs) ->
        $log.info 'mfSpyScrollTo ', element

        # Previous nav item
        oldItem = undefined

        # Helper to broadcast position changes to all navication items
        broadcast = (navItem) ->
            if navItem and oldItem isnt navItem
                oldItem = navItem
                msg =
                    navItem: navItem
                scope.$broadcast "spyScrollTo", msg

        # Check if current position has passed target element position
        checkPosition = ()->
            currentPosition = scrollToService.currentYPosition()
            # Check if we are at the bottom of screen
            if document.body.scrollTop > 0 and document.body.scrollTop is (document.body.offsetHeight - document.body.clientHeight) or document.body.scrollTop is (document.body.scrollHeight - document.body.clientHeight)
                #$log.info "last one selected", document.body.scrollTop
                broadcast scrollToService.navItems[-1..][0]
            else
                # Else loop the location
                for item in scrollToService.navItems by -1
                    if item.position < currentPosition
                        broadcast item
                        break

        # Bind debonced position check to scroll and resize
        deboncedCheckPosition = _.debounce(checkPosition, 50)
        angular.element(window).bind "scroll", ->
            deboncedCheckPosition()
        # TODO: Resize should be handled too
        #angular.element(window).bind "resize", ->
         #   deboncedCheckPosition()

]




###
* Scroll to anchor navigation directive to handle scrolling to the navigation target on navigation element clicks
* Uses controller of mfScrollTo directive above to save navigation items
###
mdl.directive 'mfScrollTo', ['$document', '$window', '$location', '$log', '$timeout',
($document, $window, $location, $log, $timeout)->

    restrict: 'A'
    require: [ "?^mfSpyScrollTo" ]
    scope:
        mfScrollTo: '@'
    link: (scope, element, attr, spyScrollToCtrls) ->

        unless scope.mfScrollTo
            $log.error 'Set element where to be scrolled'
            return

        offset = attr.offset or 100

        # spyScrollToCtrls refers to controller presented in mfScrollTo directive - so we have access to shared service
        spyScrollCtrl = spyScrollToCtrls[0]

        # Add anvigation items to service
        spyScrollCtrl.addNavItem
            element: element
            anchor: scope.mfScrollTo

        element.bind 'click', (event) ->
            # Prevent default
            alreadyScrolling = true
            event.preventDefault() if event.preventDefault
            event.stopPropagation() if event.stopPropagation
            event.stopImmediatePropagation() if event.stopImmediatePropagation
            offset = attr.offset or 100
            #$log.info 'Scrolling to',  scope.mfScrollTo, 'with offset', offset
            spyScrollCtrl.scrollToElWithOffset scope.mfScrollTo, offset
            return false

        scope.$on 'spyScrollTo', (event, args) ->
            navItem = args.navItem
            toggleClass = toggleClass or 'selected'

            if navItem.element is element
                #$log.info "elem #{element[0].href} selected!"
                element.addClass 'selected'
            else
                #$log.info "elem #{element[0].href} not selected!"
                element.removeClass 'selected'
]

