#!/usr/bin/env sh

set -e

DIR=$(cd "$(dirname "$0")"; pwd)

if ! egrep -q "source .*/aliases" ~/.zshrc; then
  echo "\nsource ${DIR}/aliases" >> ~/.zshrc
fi
