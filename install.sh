#!/usr/bin/env bash


echo "type sudo password"
sudo -v

readonly OS_TYPE="$(uname -s)"

if [ "${OS_TYPE}" = "Darwin" ]; then
  curl -fsSL "https://raw.githubusercontent.com/puutaro/cmdclick2/refs/heads/master/install/mac/installer.sh" | bash
else
  curl -fsSL "https://raw.githubusercontent.com/puutaro/cmdclick2/refs/heads/master/install/linux/installer.sh" | bash
fi
