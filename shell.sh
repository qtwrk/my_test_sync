#!/bin/bash 

if [[ "$1" == "" ]] ; then 
  echo "you need to specify the domain "
  exit 
else 
  domain=$1
fi 
if [[ ! -f crawler.sh ]] ; then 
  wget -O crawler.sh https://www.litespeedtech.com/packages/litemage2.0/M2-crawler.sh
fi 
if [[ ! -f ip.txt ]] ; then 
  wget -O ip.txt https://quic.cloud/ips?ln 
fi 

while IFS= read -r line ; do
  check_server=$(curl -sS -I -XGET -k https://$line)
  if ! echo $check_server | grep -q refused ; then 
    sed -i "16s/CURL_OPTS=.*/CURL_OPTS='--resolve ${domain}:443:${line}'/"  crawler.sh
    bash crawler.sh -m -w -d https://${domain}/
    bash crawler.sh -m -d https://${domain}/
    bash crawler.sh -d https://${domain}/
    bash crawler.sh -w -d https://${domain}/
  fi 
done < ip.txt
