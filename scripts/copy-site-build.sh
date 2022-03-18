#! /bin/bash

if [[ ${UID} != 0 ]];
then 
    echo 'This script needs to be executed as root' 
    exit 1
fi

sudo cp -r ../build/* ../data/webserver-data/swag/www/
