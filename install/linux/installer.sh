#!bin/bash

echo ${0}
OS_TYPE="linux"
SOURCE_DIR_PATH=$(echo $(cd $(dirname $0) && pwd))
DIFBK_INSTALL_SOURCE_DIR="$(echo "$(cd $(dirname $0)/../../ && pwd)")/${OS_TYPE}/srcs/"
DIFBK_INSTALL_TARGET_DIR="/usr/local/bin"
# fd install
sudo apt install -y fd-find && sudo ln -s $(which fdfind) /usr/local/bin/fd
# repgrep-all install
sudo apt install ripgrep pandoc poppler-utils ffmpeg -y
wget -O - 'https://github.com/phiresky/ripgrep-all/releases/download/v0.9.6/ripgrep_all-v0.9.6-x86_64-unknown-linux-musl.tar.gz' | tar zxvf - && sudo mv ripgrep_all-v0.9.6-x86_64-unknown-linux-musl/rga* /usr/local/bin
# colordiff rcs(merge) install 
sudo apt-get install -y colordiff rcs

# difbk install
echo "sudo cp -arvf \"${DIFBK_INSTALL_SOURCE_DIR}\"/* \"${DIFBK_INSTALL_TARGET_DIR}\"/"
sudo cp -arvf "${DIFBK_INSTALL_SOURCE_DIR}"/* "${DIFBK_INSTALL_TARGET_DIR}"/
sudo chmod -R +x "${DIFBK_INSTALL_TARGET_DIR}"