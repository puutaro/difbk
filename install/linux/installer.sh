#!/bin/bash
set -euo pipefail

readonly APP_NAME="difbk"
readonly USR_LOCAL_BIN="/usr/local/bin"

# 1. 実行ユーザーとホームディレクトリの安全な取得
if [ -n "${SUDO_USER:-}" ]; then
    REAL_USER="$SUDO_USER"
else
    REAL_USER="$(whoami)"
fi
REAL_HOME="$(eval echo "~${REAL_USER}")"

echo "Installing for user: ${REAL_USER} (${REAL_HOME})"

# 2. apt パッケージのインストール
sudo apt-get update -y
sudo apt-get install -y fd-find ripgrep pandoc poppler-utils ffmpeg colordiff rcs git wget

# fd のシンボリックリンク
if [ ! -f "${USR_LOCAL_BIN}/fd" ]; then
    sudo ln -s "$(which fdfind)" "${USR_LOCAL_BIN}/fd"
fi

# 3. ripgrep-all (rga) インストール (一時フォルダで作業)
TMP_DIR="$(mktemp -d)"
wget -O - 'https://github.com/phiresky/ripgrep-all/releases/download/v0.9.6/ripgrep_all-v0.9.6-x86_64-unknown-linux-musl.tar.gz' | tar zxvf - -C "${TMP_DIR}"
sudo mv "${TMP_DIR}"/ripgrep_all-*/rga* "${USR_LOCAL_BIN}/"
rm -rf "${TMP_DIR}"

# 4. fzf インストール
readonly FZF_DIR="${REAL_HOME}/.fzf"
if [ ! -d "${FZF_DIR}" ]; then
    git clone https://github.com/junegunn/fzf.git "${FZF_DIR}"
    sudo chown -R "${REAL_USER}:${REAL_USER}" "${FZF_DIR}"
fi
# stdinがパイプで埋まっているため </dev/null や --all オプションを指定して自動インストール
"${FZF_DIR}/install" --all </dev/null

# 5. difbk インストール
readonly INSTALL_DIR_PATH="${REAL_HOME}/.${APP_NAME}"
if [ -d "${INSTALL_DIR_PATH}" ]; then
    sudo rm -rf "${INSTALL_DIR_PATH}"
fi

git clone https://github.com/puutaro/difbk.git "${INSTALL_DIR_PATH}"
sudo chown -R "${REAL_USER}:${REAL_USER}" "${INSTALL_DIR_PATH}"

readonly SRC_DIR_PATH="${INSTALL_DIR_PATH}/srcs"
readonly APP_PATH="${SRC_DIR_PATH}/${APP_NAME}"
readonly APP_LINK_PATH="${USR_LOCAL_BIN}/${APP_NAME}"

sudo rm -f "${APP_LINK_PATH}"
sudo ln -s "${APP_PATH}" "${APP_LINK_PATH}"

echo "Installation complete!"
