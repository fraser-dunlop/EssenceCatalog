
# Tools you need:
#
# Conjure + SR + Minion, Mac OS X binaries for these are provided in the repo,
# previously installed versions will be tried first.
#
# parallel, timelimit
# For Mac OS X: "brew install parallel timelimit" should install both.
# Linux users are expected to know wht they are doing :)
#
# There is one small problem with the way we run conjure here.
# Ignore this if you have compiled Conjure from source.
# If you haven't, it might have problems locating the rules database file.
# As a temporary workaround, please copy the conjure.rulesdb file next
# to the essence file.
# i.e. "cp ../../tools/conjure.rulesdb ."



# run Conjure to generate all models for this Essence
# you should only need this if you are writing a new Essence,
# normally the Essence' outputs will be in the repository already.

../../tools/runExperiment_conjure.sh



# solve each (model,parameter) pair.

export PARALLEL="-jX" # X is the number of cores you want to use
../../tools/runExperiment_solveAll.sh



# to populate a database of results and view plots
# ( these will require a working haskell installation and some packages:
# cabal install split scotty text sqlite-simple shakespeare-text )

../../tools/runExperiment_collectDataToDB.sh
cd ../../tools
runhaskell browsePlots.hs


