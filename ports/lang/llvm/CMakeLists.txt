
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (LLVM)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package description
set (LLVM_VERSION        "2.7" )
set (LLVM_SOURCE_ARCHIVE "llvm-${LLVM_VERSION}.tgz" )
set (LLVM_URL            "http://llvm.org/releases/${LLVM_VERSION}/${LLVM_SOURCE_ARCHIVE}" )
set (LLVM_SVN            "http://llvm.org/svn/llvm-project/llvm/trunk")

set (CLANG_SVN           "http://llvm.org/svn/llvm-project/cfe/trunk")

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (LLVM_FORCE_BUILD  "Force build and installation of package?"      NO  )
option (LLVM_FROM_REPOS   "Install package from repository?"              YES )
option (LLVM_ENABLE_CLANG "Enable LLVM native C/C++/Objective-C compiler" YES )
option (LLVM_ENABLE_ADA   "Enable LLVM Ada front-end"                     ON  )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_package (Subversion)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (LLVM_FROM_REPOS)
  set (LLVM_FORCE_BUILD TRUE)
endif (LLVM_FROM_REPOS)

##__________________________________________________________
## Locate source file to build from

find_file (LLVM_SOURCE ${LLVM_SOURCE_ARCHIVE}
  PATHS ${LLVM_SOURCE_DIR}
  )

if (NOT LLVM_SOURCE)
  set (LLVM_SOURCE ${LLVM_URL})
endif (NOT LLVM_SOURCE)

##__________________________________________________________
## Build package from source

ExternalProject_Add (llvm
  PREFIX ${PROJECT_BINARY_DIR}
  DOWNLOAD_DIR download
  SOURCE_DIR source
  SVN_REPOSITORY ${LLVM_SVN}
  URL ${LLVM_SOURCE}
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-optimized
  INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
  )

##__________________________________________________________
## Enable LLVM native C/C++/Objective-C compiler

if (LLVM_ENABLE_CLANG)

  if (Subversion_SVN_EXECUTABLE)
    
    ExternalProject_Add_Step (llvm clang
      COMMAND ${Subversion_SVN_EXECUTABLE} co ${CLANG_SVN} clang
      COMMENT "[LLVM] Checking out sources for Clang ..."
      DEPENDEES patch
      DEPENDERS configure
      WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/source/tools
      )
    
  else (Subversion_SVN_EXECUTABLE)
    
    message (STATUS "[LLVM] Unable to get sources for clang - missing Subversion!")

  endif (Subversion_SVN_EXECUTABLE)
  
endif (LLVM_ENABLE_CLANG)

##__________________________________________________________
## Enable LLVM Ada front-end

if (LLVM_ENABLE_ADA)

endif (LLVM_ENABLE_ADA)
