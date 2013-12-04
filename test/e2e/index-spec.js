'use strict';

// Jasmin matchers
// toEqual, toBe, toBeDefined, toBeUndefined, toBeNull, toBeTruthy, toBeFalsy, toContain,, toBeGreaterThan, toBeLessThan
// not.toEqal...

// webdriver  element methods
// click, sendKeys, getTagName, getCssValue, getAttribute, getText, getSize, getLocation, isEnabled, isSelected, submit, clear, isDisplayed, getOuterHtml
// getInnerHtml, findElements, isElementPresent, evaluate, findElement, $, $$, find, isPresent

describe('Index page', function() {

  it('should load the homepage', function() {

    browser.get('/')

    // Fill and submit the join-beta-testing  form
    var launchInput1 = $('#entry_1805485991')
    var launchInput2 = $('#entry_1110524157')

    launchInput1.sendKeys('e2e testing')
    launchInput2.sendKeys('e2e@te.st')
    launchInput2.submit()

    // Navigate the page by links
    var link1 = $('[href="#content-1"]');
    var link2 = $('[href="#content-2"]');
    var link3 = $('[href="#content-3"]');
    var link4 = $('[href="#content-4"]');

    expect(link1.isPresent());
    expect(link2.isPresent());
    expect(link2.getText()).toBe('MIRROR MONKEY');
    expect(link1.getAttribute('class')).not.toContain('selected');
    expect(link2.getAttribute('class')).not.toContain('selected');
    link2.click();
    expect(link1.getAttribute('class')).not.toContain('selected');
    expect(link2.getAttribute('class')).toContain('selected');
    link1.click();
    expect(link1.getAttribute('class')).toContain('logo');
    expect(link2.getAttribute('class')).not.toContain('selected');
    link3.click();
    expect(link1.getAttribute('class')).not.toContain('selected');
    expect(link2.getAttribute('class')).not.toContain('selected');
    expect(link3.getAttribute('class')).toContain('selected');
    link4.click();
    expect(link1.getAttribute('class')).not.toContain('selected');
    expect(link2.getAttribute('class')).not.toContain('selected');
    expect(link3.getAttribute('class')).not.toContain('selected');
    expect(link4.getAttribute('class')).toContain('selected');

  });

});
