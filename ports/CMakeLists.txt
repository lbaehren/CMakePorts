
##____________________________________________________________________
##                                                     Port categories

add_subdirectory (archivers)
add_subdirectory (devel)
add_subdirectory (editors)
add_subdirectory (graphics)
add_subdirectory (lang)
add_subdirectory (math)
add_subdirectory (multimedia)
add_subdirectory (net)
add_subdirectory (parallel)
add_subdirectory (science)
add_subdirectory (textproc)
add_subdirectory (www)
add_subdirectory (x11)

##____________________________________________________________________
##                                                Package dependencies

add_dependencies (cloog polylib ppl)

## ___ devel _________________

add_dependencies (apr-util apr)
add_dependencies (bison help2man)
add_dependencies (cmake git)
add_dependencies (doxygen swig)
add_dependencies (git curl)
add_dependencies (libmpc mpfr)
add_dependencies (mpfr gmp)
add_dependencies (ppl gmp)
add_dependencies (subversion swig expat serf)

## ___ editors ___________________________________

add_dependencies (nedit lesstif)

## ___ graphics __________________________________

add_dependencies (paraview treecc)

## ___ lang ______________________________________

add_dependencies (guile gmp)
add_dependencies (python readline)

## ___ multimedia ________________________________

add_dependencies (libvpx yasm)
add_dependencies (mplayer libvpx)

## ___ net _______________________________________

add_dependencies (curl openssl)

## ___ science ___________________________________

add_dependencies (casacore hdf5 wcslib cfitsio bison)
add_dependencies (dal casacore doxygen)
add_dependencies (duchamp wcslib cfitsio)
add_dependencies (hdf5 openmpi szip)

## ___ www _______________________________________

add_dependencies (neon openssl)

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
