#!/bin/bash

USER_ARGS=""
if [[ $1 == "test" ]]
then
    USER_ARGS="- test"
fi

# Exit on error
set -e

# cd into script directory
cd "$(dirname "$(readlink -f "$0")")"

echo '===== BUILD ====='
jai build.jai -import_dir modules $USER_ARGS
echo '====== RUN ======'
./bin/exec
echo '================='
