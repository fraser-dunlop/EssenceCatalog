#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

nb_cores=$1
scripts/solutions/gen_conjure_commands.sh
scripts/solutions/gen_solutions.sh $nb_cores
scripts/solutions/collect_info.sh
scripts/solutions/clean_up.sh

