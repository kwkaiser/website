#! /bin/bash

if [[ ${UID} != 0 ]];
then 
    echo 'This script needs to be executed as root' 
    exit 1
fi

nginx_conf_path='../data/webserver-data/swag/nginx/site-confs'
sudo cp ../conf/deploy-nginx.conf "${nginx_conf_path}/default"
sudo cp ../conf/deploy-umami.conf "${nginx_conf_path}/analytics"
