# running the pipeline ----------------------------------------------------------------------------
targets::tar_make()

# checking the workflow ---------------------------------------------------------------------------
targets::tar_visnetwork() # check the pipeline

# checking the results ----------------------------------------------------------------------------
targets::tar_load("mtcars_proper")
targets::tar_load("test_modules_1")
