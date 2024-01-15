#!/usr/bin/env sh

set -e

elm-test
./optimize.sh src/Main.elm
