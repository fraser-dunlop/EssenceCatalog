parallel --halt --eta "conjure sym {} ; ~/repos/gap-system/ferret/symmetry_detect --json {}-json > {}-sym ; echo done {}" ::: $(find problems -name *.essence)
