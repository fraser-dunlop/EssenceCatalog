#!/bin/bash

parallel -j2 ./run.sh ::: baseline implied ::: 60 600 3600
