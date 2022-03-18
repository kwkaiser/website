#! /bin/bash

cd $(dirname ${0})

if [[ ${UID} != 0 ]];
then
    echo 'This script must be run as root'
    exit 1
fi


git pull
docker-compose -f ../docker/deployed-compose.yml down
./subst.sh
./copy-site-build.sh
./copy-site-confs.sh
docker-compose -f ../docker/deployed-compose.yml up -d
