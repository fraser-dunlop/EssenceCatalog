#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

find problems -name '*.eprime-dimacs' -delete
find problems -name '*.eprime-minion' -delete
find problems -name '*.eprime-info'   -delete
find problems -name '*.eprime-infor'  -delete

