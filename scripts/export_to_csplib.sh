#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

ROOT_DIR=$(pwd)

pushd problems > /dev/null                              # go through all csplib problems in the catalog
for prob in csplib-*;
do
    prob_base=${prob:7}
    cp "${prob}/"*.essence "${ROOT_DIR}/csplib/Problems/${prob_base}/models"
done
popd > /dev/null

