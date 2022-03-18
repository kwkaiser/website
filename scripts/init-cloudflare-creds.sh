#! /bin/bash

if [[ ${UID} != 0 ]];
then 
    echo 'This script needs to be executed as root' 
    exit 1
fi

ini_path='../data/webserver-data/swag/dns-conf/cloudflare.ini'

read -p 'Enter your website cloudflare email: ' email
read -s -p 'Enter your website cloudflare API key: ' api_key

echo "dns_cloudflare_email=${email}" > ${ini_path}
echo "dns_cloudflare_api_key=${api_key}" >> ${ini_path}

chmod 600 ${ini_path}

