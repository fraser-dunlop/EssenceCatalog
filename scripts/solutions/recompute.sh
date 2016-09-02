#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

export LIMIT_TIME=${LIMIT_TIME:-60}

nb_cores=$1
scripts/solutions/gen_conjure_commands.sh
scripts/solutions/gen_solutions.sh $nb_cores || true        # allowed to fail due to SR timeouts
scripts/solutions/collect_info.sh
scripts/solutions/clean_up.sh

