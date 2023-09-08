#!/bin/bash

# Exit on error
set -e

# cd into script directory
cd "$(dirname "$(readlink -f "$0")")"

echo '===== BUILD ====='
jai build.jai -import_dir modules
echo '====== RUN ======'
./bin/exec
echo '================='
