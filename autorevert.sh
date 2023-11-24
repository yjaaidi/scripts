#!/usr/bin/env bash

set -e

if [ $# -ne 1 ]; then
    COMMAND=$(basename $0)
    echo "Usage: $COMMAND <limit in minutes>"
    exit 1
fi

LIMIT=$(( $1 * 60 ))

function logWaiting() {
  echo -ne "\r\033[K👀 Waiting for changes to start timer..."
}

logWaiting

while true; do
  GIT_STATUS=$(git status --porcelain)

  # Start timer when user starts making changes.
  if [ -z "$STARTED" ] && [ -n "$GIT_STATUS" ]; then
    STARTED=$(date +%s)
  fi

  # User is making changes.
  if [ -n "$STARTED" ]; then

    # Compute remaining time.
    REMAINING_TIME=$(($STARTED + $LIMIT - $(date +%s)))
    # Keep it positive.
    REMAINING_TIME=$(($REMAINING_TIME > 0 ? $REMAINING_TIME : 0))
    
    # Log remaining time.
    if [ $REMAINING_TIME -gt 60 ]; then
      echo -ne "\r\033[K\033[1;32)mReverting in $(($REMAINING_TIME / 60)) minutes and $(($REMAINING_TIME % 60)) seconds...\033[0m"
    else
      echo -ne "\r\033[K\033[1;31)mReverting in $REMAINING_TIME seconds...\033[0m"
    fi

    # If user has been making changes for more than $LIMIT, revert:
    if [ $(($(date +%s) - $STARTED)) -gt $LIMIT ]; then
      git reset --hard > /dev/null
      git clean -df > /dev/null
      echo -ne "\r\033[K🧹 Changes reverted! Waiting for changes to start timer again."
      STARTED=""
    fi

    # Detect when user stops making changes:
    if [ -z "$GIT_STATUS" ]; then
      logWaiting
      STARTED=""
    fi
  fi

  # We don't need this to be super reactive, 5 seconds is fine.
  sleep 5
done
