#! /bin/bash

cd $(dirname "$0")

function sed-nav () {
    sed -i "s#{replace-nav}#$(cat ../src/nav.html)#g" $1
}

export sed-nav

rm -rf ../build
cp -r ../src ../build

find ../build -name "*.html" -exec sed-nav {} \;