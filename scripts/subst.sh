#! /bin/bash

cd $(dirname "$0")

function sed-parts () {
    # Substitute in nav
    local nav=$(cat ../src/subst/nav.html)
    local filled=$(perl -p -e "s#{replace-nav}#${nav}#g" ${1})
    echo ${filled} > ${1}

    # Substitute in header
    local header=$(cat ../src/subst/header.html)
    local filled=$(perl -p -e "s#{replace-header}#${header}#g" ${1})
    echo ${filled} > ${1}

    sed -i 's# @ #@#g' ${1}
}

export -f sed-parts

rm -rf ../build
cp -rf ../src ../build

find ../build -name "*.html" -exec /bin/bash -c 'sed-parts {}' \;