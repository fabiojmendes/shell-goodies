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

address=$(dig +short myip.opendns.com @resolver1.opendns.com)

if [[ -z "$address" ]]; then
  echo "no IPv4 address found"
  exit 1
elif [[ "$old" == "$address" ]]; then
  echo "IPv4 address unchanged"
  exit
fi

echo "Executing update..."

# update dynv6
curl "https://ipv4.dynv6.com/api/update" --fail -sS -G \
  -d ipv4=auto \
  -d token=$DYNAV6_TOKEN \
  -d hostname=$hostname

# save current address
echo $address > $file
