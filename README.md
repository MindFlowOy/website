# Target for this Mind Flow www project is to make www site considering

- [x] inbound: problems with weight? tired? stess?

- [x] collecting leads

- [x] coolness

- [] inform visitors about their place in marketing pipeline: tests, links etc.

- [] outbound: our contacts, pricing etc


Hubspot's Marketing Gardner [software] [http://www.hubspot.com/].


## installation

    npm install -g docpad

    npm install

## running

    docpad run

## publishing
    First time only:

        git remote add target https://github.com/MindFlowOy/mindflowoy.github.io

    Then

        docpad deploy-ghpages --env static

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

