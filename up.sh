#!/usr/bin/env bash

# This script starts a local devnet using Docker Compose. We have to use
# this more complicated Bash script rather than Compose's native orchestration
# tooling because we need to start each service in a specific order, and specify
# their configuration along the way. The order is:
#
# 1. Start L2, inserting the compiled contract artifacts into the genesis.
# 2. Start the rollup driver.


set -eu
mkdir -p .config

L2_URL="http://localhost:9545"

# Helper method that waits for a given URL to be up. Can't use
# cURL's built-in retry logic because connection reset errors
# are ignored unless you're using a very recent version of cURL
function wait_up {
  echo -n "Waiting for $1 to come up..."
  i=0
  until curl -s -f -o /dev/null "$1"
  do
    echo -n .
    sleep 0.25

    ((i=i+1))
    if [ "$i" -eq 300 ]; then
      echo " Timeout!" >&2
      exit 1
    fi
  done
  echo "Done!"
}

# TODO: Setup L2 execution engine w/ placing the JWT auth in .config
# hexdump -vn32 -e'8/4 "%08X" 1 "\n"' /dev/urandom > .config/jwt-secret.txt

docker-compose up -d l2
wait_up $L2_URL

L1_RPC_URL=$(cat .config/l1_rpc_url.txt) docker-compose up -d op-node
