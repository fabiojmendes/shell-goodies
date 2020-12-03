#!/usr/bin/env zsh
set -e

echo "Starting seed generation"

if [ -f "seed.iso" ]; then
  echo "error: seed.iso already exists"
  exit 1
fi

cmd=$(basename "$0")
dir=$(dirname "$0")
host=$1
if [ ! -n "$host" ]; then
  echo "usage: $cmd <hostname>"
  exit 1
fi

temp=$(mktemp -d -t ${cmd}-XXXX)
trap "rm -rf $temp" EXIT
echo "Using $temp for generation"

cp $dir/user-data $temp
sed "s/localhost/$host/" $dir/meta-data > $temp/meta-data

genisoimage -output seed.iso \
  -input-charset UTF-8 \
  -volid cidata \
  -joliet -rock \
  $temp/*
