#!/bin/bash -e
hostname=$1

if [[ -z "$hostname" || -z "$DYNAV6_TOKEN" ]]; then
  echo "Usage: DYNAV6_TOKEN=<auth-token> $0 your-name.dynv6.net"
  exit 1
fi

file=/var/cache/dynv6/addr4

if [[ ! -f "$file" ]]; then
  mkdir -p $(dirname $file)
  touch $file
fi

old=$(<$file)

# address=$(dig +short myip.opendns.com @resolver1.opendns.com)
address=$(upnpc -u 'http://10.0.0.1:5000/Public_UPNP_gatedesc.xml' -s | awk '/ExternalIPAddress/ {print $3}')

if [[ -z "$address" ]]; then
  echo "no IPv4 address found"
  exit 1
elif [[ "$old" == "$address" ]]; then
  echo "IP $address unchanged, skipping update"
  exit
fi

echo "Executing update from $old to $address"

# update dynv6
curl "https://ipv4.dynv6.com/api/update" --fail -sS -G \
  -d ipv4=auto \
  -d token=$DYNAV6_TOKEN \
  -d hostname=$hostname

# save current address
echo $address > $file
