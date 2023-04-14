# one time initialisation -------------------------------------------------------------------------
install.packages("targets")
targets::use_targets() # will create "_targets.R" file in the project root with some boilerplate code

# checking the validity of the workflow -----------------------------------------------------------
targets::tar_manifest()
targets::tar_visnetwork() # to see the pipeline and check for correctness.

# running the pipeline ----------------------------------------------------------------------------
targets::tar_make()
