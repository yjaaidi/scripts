#!/usr/bin/env sh

set -e

# check if there is a --prefix argument and fallback to mc otherwise

if [ "$1" = "--prefix" ]; then
  PREFIX="$2"
  shift 2
fi

if [ -z "$PREFIX" ]; then
  PREFIX="mc"
fi

if [ -z "$1" ]; then
  echo "Usage: $0 [--prefix <prefix>] <app-name>"
  exit 1
fi
APP_NAME="$1"

export NX_SKIP_GH_PUSH=true

pnpm create nx-workspace \
  --appName "$APP_NAME" \
  --bundler esbuild \
  --ci github \
  --e2e-test-runner none \
  --preset angular-monorepo \
  --ssr false \
  --style css \
  --unit-test-runner vitest \
  --prefix "$PREFIX" \
  "$APP_NAME"
