#!/bin/bash -e

if ! command -v dig &> /dev/null; then
  echo "dig command is required"
  echo "Install it using apt install dnsutils"
  echo "Installation failed"
  exit 1
fi

if [[ -f /etc/default/dynv6 ]]; then
  echo "Config file already exists, skipping"
else
  echo "Copying config file"
  cp ./dynv6 /etc/default
fi

echo "Copy dynv6 main script"
cp ./dynv6.sh /usr/local/sbin

echo "Copy dynv6 systemd scripts"
cp ./dynv6.{service,timer} /etc/systemd/system

echo "Reload systemd"
systemctl daemon-reload
systemctl enable dynv6.timer
systemctl start dynv6.timer

echo "Installing weekly cache clear"
target=/etc/cron.weekly
if [[ -d $target ]]; then
  cp dynv6-cache $target
else
  echo "$target not found"
fi

echo "Instalation completed"
