
##____________________________________________________________________
## Port categories

add_subdirectory (archivers)
add_subdirectory (devel)
#add_subdirectory (lang)
#add_subdirectory (net)
add_subdirectory (parallel)
add_subdirectory (science)

##____________________________________________________________________
## Package dependencies

## ___ devel _________________

## ___ science _______________

add_dependencies (hdf5 openmpi szip)
