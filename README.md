# Target for this Mind Flow www project is to make www site considering

- [x] inbound: problems with weight? tired? stess?

- [x] collecting leads

- [x] coolness

- [] inform visitors about their place in marketing pipeline: tests, links etc.

- [] outbound: our contacts, pricing etc


At the time beeing this more like skeleton of web project, but it should be easy and fast to add new pages/functionality.

## There are many technologies involved to this project:

- Docpad and its plugins as main 'web framework'

- Grunt for JS/CSS/image optimation

- Angular as a JavaScript framework and Karma and Protractor for unit/E2E testing

- CoffeeScript for JavaScript generation

- Jade as HTML template language

- Stylus for CSS preprosessing

- And of course libaries like Lodash, Modernizer, some shims etc

So not the most simplest stack for static web pages - but once you know them you can't live without.

## installation

    npm install -g docpad

    npm install

## running

    docpad run [-p 9999]


## editing

    look editable content from /src/documents/index-articles/[en|fi]-directory
    images are under /src/files/img-directory

## publishing
    First time only:
        git remote add target git@github.com:MindFlowOy/mindflowoy.github.io.git

    To deploy github

        First optimize JavaScript, CSS and images by running

            grunt

        Then deploy by

        docpad deploy-ghpages --env static

    And then browse to  http://mindflowoy.github.io/

## testing

    Selenium for e2e tests:

            First time only:

                node_modules/protractor/bin/install_selenium_standalone
                node_modules/protractor/bin/webdriver-manager update

            If using real selenium(not needed by default as chromedriver is used):

                ./selenium/start

            Then

                ./scripts/unit.sh

                ./scripts/e2e.sh




# License

