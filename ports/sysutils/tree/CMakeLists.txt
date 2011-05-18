
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Tree)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  Options
##
## ==============================================================================



## ==============================================================================
##
##  Package information
##
## ==============================================================================

set (Tree_VERSION        "1.5.3" )
set (Tree_SOURCE_ARCHIVE "tree-${Tree_VERSION}.tgz" )
set (Tree_URL            "ftp://mama.indstate.edu/linux/tree/${Tree_SOURCE_ARCHIVE}" )
set (Tree_SVN            "" )

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

## Locate source file to build from

find_file (HAVE_Tree_SOURCE ${Tree_SOURCE_ARCHIVE}
  PATHS ${Tree_SOURCE_DIR}
  )

if (NOT HAVE_Tree_SOURCE)
  set (HAVE_Tree_SOURCE ${Tree_URL})
endif (NOT HAVE_Tree_SOURCE)

## Build package from source

ExternalProject_Add (tree
  PREFIX ${Tree_BINARY_DIR}
  DOWNLOAD_DIR ${Tree_BINARY_DIR}/download
  SOURCE_DIR ${Tree_BINARY_DIR}/source
  URL ${HAVE_Tree_SOURCE}
  CMAKE_ARGS -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  INSTALL_COMMAND sudo make install
  )

## Copy CMakeLists.txt into place
ExternalProject_Add_Step (tree tree_cmake
  COMMAND cp ${Tree_SOURCE_DIR}/tree.cmake ${Tree_BINARY_DIR}/source/CMakeLists.txt
  COMMENT "Moving CMakeLists.txt into place ..."
  DEPENDEES patch
  DEPENDERS configure
  WORKING_DIRECTORY ${Tree_BINARY_DIR}/source
  )
