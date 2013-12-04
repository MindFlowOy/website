#!/bin/bash

BASE_DIR=`dirname $0`

echo ""
echo "Starting Protactor  (https://github.com/angular/protractor/blob/master/docs/getting-started.md)"
echo $BASE_DIR
echo "-------------------------------------------------------------------"

$BASE_DIR/../node_modules/protractor/bin/protractor $BASE_DIR/../test/protractor.conf.js $*
