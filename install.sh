#!/usr/bin/env sh

set -e

DIR=$(cd "$(dirname "$0")"; pwd)

if ! grep -q "source ${DIR}/aliases" ~/.zshrc; then
  echo "\nsource ${DIR}/aliases" >> ~/.zshrc
fi
