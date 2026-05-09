#!/bin/bash
source .env
# forge script script/AwaAccount.s.sol --broadcast --rpc-url $RPC_URL --account $ACCOUNT
forge script script/ExecutorModule.s.sol --broadcast --rpc-url $RPC_URL --account $ACCOUNT
