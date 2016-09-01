#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

nb_cores=$1
scripts/modelling/gen_conjure_commands.sh
scripts/modelling/gen_models.sh $nb_cores

