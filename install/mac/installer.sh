#!/bin/bash
set -euo pipefail

readonly APP_NAME="difbk"

# 1. Homebrew の PATH を自動補正 (Apple Silicon / Intel 両対応)
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# 2. 必要なパッケージを Homebrew で一括インストール
brew install coreutils findutils diffutils wget gzip gnu-sed fd ripgrep-all colordiff rcs

# 3. インストール先・変数の定義
readonly INSTALL_DIR_PATH="${HOME}/.${APP_NAME}"
readonly SRC_DIR_PATH="${INSTALL_DIR_PATH}/srcs"
readonly APP_PATH="${SRC_DIR_PATH}/${APP_NAME}"
readonly USR_LOCAL_BIN="/usr/local/bin"
readonly APP_LINK_PATH="${USR_LOCAL_BIN}/${APP_NAME}"

# 4. 既存ディレクトリのクリーンアップ
if [ -d "${INSTALL_DIR_PATH}" ]; then
    rm -rf "${INSTALL_DIR_PATH}"
fi

# 5. リポジトリのクローンと権限付与
git clone https://github.com/puutaro/difbk.git "${INSTALL_DIR_PATH}"
chmod +x "${APP_PATH}"

# 6. /usr/local/bin の存在確認とシンボリックリンク作成
if [ ! -d "${USR_LOCAL_BIN}" ]; then
    sudo mkdir -p "${USR_LOCAL_BIN}"
fi

sudo rm -f "${APP_LINK_PATH}"
sudo ln -s "${APP_PATH}" "${APP_LINK_PATH}"

echo "Installation complete!"
