'use strict';

/* jasmine specs for directives go here */

describe('directives', function() {

    var currentYPosition = function() {
         if (window.pageYOffset) return window.pageYOffset;
         if (document.documentElement && document.documentElement.scrollTop) {
          return document.documentElement.scrollTop;
         }
         if (document.body.scrollTop) return document.body.scrollTop;
         return 0;
    };

    beforeEach(module('common.drctv'));

    beforeEach(inject(function($rootScope, $compile) {
         var target = angular.element("<div id='target1' style='position:absolute; top:200px;'></div>");
         $('body').height(window.innerHeight * 2).append(target);
         return window.scrollTo(0, 0);
    }));

    describe('scroll to directive', function() {
        it('should render and scroll correctly', function() {
           /*
            module(function($provide) {
                $provide.value('version', 'TEST_VER');
            });
            */
            inject(function($compile, $rootScope) {
                var scope = $rootScope.$new();
                var navElement = $compile('<nav><a href="#target1" data-mf-scroll-to="target1">TEST1</a><a href="#target2" data-mf-scroll-to="target2">TEST2</a></nav>')($rootScope);
                var aElement1 = angular.element(navElement.find('a')[0])
                var aElement2 = angular.element(navElement.find('a')[1])

                expect(currentYPosition()).toEqual(0);
                expect(aElement1.text()).toEqual('TEST1');
                expect(aElement1.hasClass('selected')).toEqual(false);
                expect(aElement2.hasClass('selected')).toEqual(false);
                aElement1[0].click();
                waitsFor((function() {
                    return currentYPosition() === 100;
                }), "Current position to be 100px");
                return runs(function() {
                    dump(aElement1);
                    dump(aElement2);
                    expect(aElement1.hasClass('selected')).toEqual(true);
                    expect(aElement2.hasClass('selected')).toEqual(false);
                   return expect(currentYPosition()).toEqual(100);
                });
            });
        });
    });


});
