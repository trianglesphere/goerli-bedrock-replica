# Goerli Bedrock Devnet Replica Scripts


This aims to be a very easy way to setup replicas for the goerli
devnet.

## Initial Setup

Dependencies
- docker & docker compose
- curl
- maybe hexdump (to create jwt-secret)
- L1 Goerli Provider (websockets/IPC only)

Place a file in the `.config` directory called `l1_rpc.url.txt`
with the URL of the goerli provider that you would like to use. It
must support subscriptions.

Place a file in the `.config` directory called jwt-secret.txt. This
is a 32 byte hex encoded secret used for authenticated the rollup
node & the L2 execution engine engine API. Note that this might not
actually be fully working yet.

Build the op-node docker image and tag is as `local-op-node:latest`.
We do not yet have auto built docker images. Coming soon (tm).

## Running

```
make up
make down
make clean
```

Note you can run `make clean` without running `make down` first.

The L2 Execution engine is just a geth client & has the following
ports exposed: 9545 & 9546 for http/ws connections, respectively.

The rollup node has metrics exposed on port 7300 & has a JSON RPC
API on port 7545.

## Tips & Tricks

Use normal `cast` operations with `--rpc-url=http://localhost:9545`
to access L2 state.

Try `cast rpc --rpc-url=http://localhost:7545 optimism_syncStatus`
to see the current internal state of the rollup node. Try piping
through `jq` or looking at it with `watch` as well.
