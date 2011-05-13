
##____________________________________________________________________
##                                                     Port categories

add_subdirectory (archivers)
add_subdirectory (devel)
add_subdirectory (graphics)
add_subdirectory (lang)
add_subdirectory (net)
add_subdirectory (parallel)
add_subdirectory (science)
add_subdirectory (textproc)

##____________________________________________________________________
##                                                Package dependencies

## ___ devel _________________

add_dependencies (bison help2man)
add_dependencies (cmake git)
add_dependencies (doxygen swig)
add_dependencies (git curl)
add_dependencies (subversion swig expat)

## ___ graphics __________________________________

add_dependencies (paraview treecc)

## ___ lang ______________________________________

add_dependencies (python readline)

## ___ net _______________________________________

add_dependencies (curl openssl)

## ___ science ___________________________________

add_dependencies (casacore hdf5 wcslib cfitsio bison)
add_dependencies (dal casacore doxygen)
add_dependencies (duchamp wcslib cfitsio)
add_dependencies (hdf5 openmpi szip)

##____________________________________________________________________
##                                            Collective build targets

add_custom_target (Daily ALL
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
)

add_dependencies (Daily
  cmake
  doxygen
  mplayer
  llvm
  root
  casacore
  )
