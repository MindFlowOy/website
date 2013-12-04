'use strict'

###
AngularJS directive to scroll smoothly based on menu selection
Usage:<nav> <a mf-scroll-to='id1' [offset='value']> <a mf-scroll-to='id2' [offset='value']></a> </nav>
Inspired by: http://www.itnewb.com/tutorial/Creating-the-Smooth-Scroll-Effect-with-JavaScript
###

angular.module('common.drctv', [])
.directive 'mfScrollTo', ['$document', '$window', '$location', '$log', '$timeout'
($document, $window, $location, $log, $timeout)->

    EASY_ITERATIONS = 60

    DIRECTIONS =
        NEXT: 'next'
        PREV: 'prev'

    ###
    Retrieve the current vertical position
    @returns Current vertical position
    ###
    currentYPosition = ->
      # Firefox, Chrome, Opera, Safari
      return $window.pageYOffset  if $window.pageYOffset

      # Internet Explorer 6 - standards mode
      return $window.document.documentElement.scrollTop  if $window.document.documentElement and $window.document.documentElement.scrollTop

      # Internet Explorer 6, 7 and 8
      return $window.document.body.scrollTop  if $window.document.body.scrollTop
      0

    ###
    Get the vertical position of a DOM element
    @param eID The DOM element id
    @returns The vertical position of element with id eID
    ###
    elmYPosition = (eID) ->
      elm = document.getElementById(eID)

      if elm
        y = elm.offsetTop
        node = elm
        while node.offsetParent and node.offsetParent isnt document.body
          node = node.offsetParent
          y += node.offsetTop
        return y
      0

    # Helper to get linear easing values when direction, target and current position is known
    calculateEasyVals = (direction, target, position)->
        easyVals = []
        iteration = 0
        if direction is DIRECTIONS.NEXT
            lastVal = position
            while lastVal < target
                iteration++
                spaceToIterate = target - position
                iterationStep = Math.round(spaceToIterate / EASY_ITERATIONS)
                easyVal = position + iteration * iterationStep
                if easyVal > target
                    easyVal = target
                lastVal = easyVal
                easyVal = 0 if easyVal < 0
                easyVals.push easyVal
        else if direction is DIRECTIONS.PREV
            lastVal = position
            while lastVal > target
                iteration++
                spaceToIterate =  position - target
                iterationStep = Math.round(spaceToIterate / EASY_ITERATIONS)
                easyVal = position - iteration * iterationStep
                lastVal = easyVal
                if easyVal < target
                    easyVal = target
                easyVal = 0 if easyVal < 0
                easyVals.push easyVal

        return easyVals

    ###
    Scroll to the element with given easing positions by using Animation Frames
    ###
    easyScrollTo = (el, easing, iteration) ->
        if iteration < easing.length
            scrollToAnchorAnimationOngoing = true
            # do the scrolling itself
            $window.scrollTo(0, easing[iteration])
            iteration++

            repeatScrollTo = angular.bind @, easyScrollTo, el, easing, iteration
            requestAnimationFrame repeatScrollTo
        else
            scrollToAnchorAnimationOngoing = false

    ###
    Smooth scroll to element with a specific ID with offset
    @param el The element where to scroll to
    @param offSet Scrolling offset
    ###
    scrollToElWithOffset = (el, offSet) ->
        startY = currentYPosition()
        stopY = elmYPosition(el) - offSet
        direction = DIRECTIONS.NEXT
        if stopY < startY
            direction = DIRECTIONS.PREV

        easingVals = calculateEasyVals direction, stopY, startY
        easyScrollTo el, easingVals, 0
        return
        ###
        distance = (if stopY > startY then stopY - startY else startY - stopY)
        if distance < 100
            scrollTo 0, stopY
            return
          speed = Math.round(distance / 100)
          speed = 20  if speed >= 20
          step = Math.round(distance / 25)
          leapY = (if stopY > startY then startY + step else startY - step)
          timer = 0
          if stopY > startY
            i = startY

            while i < stopY
              # TODO: Using setTimeout with string to slow down animation (with function reference it is too fast)
              # Have not found a proper alternative yet, except using jQuery animate
              setTimeout 'window.scrollTo(0, '+leapY+')', timer * speed

              leapY += step
              leapY = stopY  if leapY > stopY
              timer++
              i += step
            return
          i = startY

          while i > stopY
            # TODO: Using setTimeout with string to slow down animation (with function reference it is too fast)
            # Have not found a proper alternative yet, except using jQuery animate
            setTimeout 'window.scrollTo(0, '+leapY+')', timer * speed

            leapY -= step
            leapY = stopY  if leapY < stopY
            timer++
            i -= step
        ###

    ###
    Helper to mark selected element by given class
    @param eI Andular element to be selected
    @param toggleClass calss to be toggled based on selection
    ###
    selectNav = (el, toggleClass)->
        toggleClass = toggleClass or 'selected'


        # Check if we are under nav tag
        if el[0].parentNode.nodeName is 'NAV'
            navLinks = angular.element(el[0].parentNode).children()
        else
            # Trying to find nav from documents
            navLinks = $document.find('nav').children()

        for selectEl, index in navLinks
            currentEl = angular.element(selectEl)
            if currentEl?[0]?.href is el?[0]?.href
                currentEl.addClass toggleClass
            else
                currentEl.removeClass toggleClass

    ###
    Directive itself
    ###
    restrict: 'A'
    scope:
        mfScrollTo: '@'
    link: (scope, element, attr) ->
        unless scope.mfScrollTo
            $log.error 'Set element where to be scrolled'
            return


        element.bind 'click', (event) ->
            # prevent default
            event.preventDefault() if event.preventDefault
            event.stopPropagation() if event.stopPropagation
            event.stopImmediatePropagation() if event.stopImmediatePropagation
            selectNav element
            offset = attr.offset or 100
            $log.info 'Scrolling to',  scope.mfScrollTo, 'with offset', offset
            scrollToElWithOffset scope.mfScrollTo, offset

            # prevent default
            return false

]
