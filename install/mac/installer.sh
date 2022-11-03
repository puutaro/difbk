#!bin/bash

echo ${0}
OS_TYPE="mac"
SOURCE_DIR_PATH=$(echo $(cd $(dirname $0) && pwd))
DIFBK_INSTALL_SOURCE_DIR="$(echo "$(cd $(dirname $0)/../../ && pwd)")/${OS_TYPE}/srcs/"
DIFBK_INSTALL_TARGET_DIR="/usr/local/bin"

# gnu cmd install
brew install coreutils findutils diffutils wget gzip gnu-sed
# fd install
brew install fd
# repgrep-all install
brew install ripgrep-all
# colordiff rcs(merge) install 
brew install colordiff colordiff rcs

# difbk install
echo "sudo cp -arvf \"${DIFBK_INSTALL_SOURCE_DIR}\"/* \"${DIFBK_INSTALL_TARGET_DIR}\"/"
sudo cp -arvf "${DIFBK_INSTALL_SOURCE_DIR}"/* "${DIFBK_INSTALL_TARGET_DIR}"/
sudo chmod -R +x "${DIFBK_INSTALL_TARGET_DIR}"