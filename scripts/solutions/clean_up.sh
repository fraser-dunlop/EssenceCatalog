#!/bin/bash

set -o nounset
set -o errexit
shopt -s nullglob

find solutions -name '*.eprime'        -delete      # it was copied from EssenceCatalog-models anyway
find solutions -name '*.dimacs'        -delete
find solutions -name '*.eprime-minion' -delete
find solutions -name '*.eprime-info'   -delete
find solutions -name '*.eprime-infor'  -delete

