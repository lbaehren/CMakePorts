
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (OPENMPI)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (OPENMPI_VERSION        "1.4.3" )
set (OPENMPI_SOURCE_ARCHIVE "openmpi-${OPENMPI_VERSION}.tar.gz" )
set (OPENMPI_URL            "http://www.open-mpi.org/software/ompi/v1.4/downloads/${OPENMPI_SOURCE_ARCHIVE}" )
set (OPENMPI_MD5            "" )
set (OPENMPI_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (OPENMPI_FORCE_BUILD    "Force build and installation of package?" NO )
option (OPENMPI_FROM_REPOS     "Install package from repository?"         NO )
option (OPENMPI_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (OPENMPI_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (OPENMPI_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindMPI)
include (FindOpenMP)

if (OPENMP_FOUND AND MPI_FOUND)
  set (OPENMPI_FOUND TRUE)
endif (OPENMP_FOUND AND MPI_FOUND)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (OPENMPI_FROM_REPOS)
  set (OPENMPI_FORCE_BUILD TRUE)
endif (OPENMPI_FROM_REPOS)

if (NOT OPENMPI_FOUND OR OPENMPI_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (OPENMPI_SOURCE ${OPENMPI_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT OPENMPI_SOURCE)
    set (OPENMPI_SOURCE ${OPENMPI_URL})
  endif (NOT OPENMPI_SOURCE)
  
  ## Build package from source
  
  if (OPENMPI_FROM_REPOS)
    
    ExternalProject_Add (openmpi
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${OPENMPI_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-mpi-f77=no --enable-mpi-f90=no
      INSTALL_COMMAND sudo make install
      )
  
  else (OPENMPI_FROM_REPOS)
    
    ExternalProject_Add (openmpi
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${OPENMPI_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-mpi-f77=no --enable-mpi-f90=no
      INSTALL_COMMAND sudo make install
      )
    
  endif (OPENMPI_FROM_REPOS)
  
else (NOT OPENMPI_FOUND OR OPENMPI_FORCE_BUILD)
  
  add_custom_target (openmpi
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[OpenMPI] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT OPENMPI_FOUND OR OPENMPI_FORCE_BUILD)
