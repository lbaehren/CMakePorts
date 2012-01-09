
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CASACORE)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (CASACORE_VERSION        "1.2.0" )
set (CASACORE_SOURCE_ARCHIVE "casacore-${CASACORE_VERSION}.tar.bz2" )
set (CASACORE_URL            "http://code.google.com/p/casacore/downloads/detail?name=${CASACORE_SOURCE_ARCHIVE}" )
set (CASACORE_SVN            "http://casacore.googlecode.com/svn/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (CASACORE_FORCE_BUILD    "Force build and installation of package?" NO  )
option (CASACORE_FROM_REPOS     "Install package from repository?"         YES )
option (CASACORE_WITH_FFTW3     "Enable FFTW3 library support?"            NO  )
option (CASACORE_WITH_HDF5      "Enable HDF5 library support?"             YES )
option (CASACORE_BUILD_TESTING  "Build the test programs?"                 NO  )
option (CASACORE_ENABLE_SHARED  "Build shared libraries?"                  YES )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindBLAS)
include (FindLAPACK)
include (FindWCSLIB)
include (FindGFortran)

if (GFORTRAN_LIBRARY)
  list (APPEND LAPACK_LIBRARIES ${GFORTRAN_LIBRARY})
endif (GFORTRAN_LIBRARY)

##__________________________________________________________
## Check for measures data

find_path (CASACORE_DATADIR ephemerides geodetic
  PATHS /sw /usr /usr/local /opt /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES share/casacore share/casacore/data
  )

##__________________________________________________________
## Check for build architectures for OSX

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  set (CASACORE_OSX_ARCHITECTURES "x86_64")
else()
  set (CASACORE_OSX_ARCHITECTURES "i386")
endif()

##__________________________________________________________
## Handle option: HDF5 library support

if (CASACORE_WITH_HDF5)
  include (FindHDF5)
  include (FindZLIB)
  include (FindMPI)
  
  if (HDF5_FOUND)
    ## Support of parallel I/O
    if (MPI_FOUND)
      list (APPEND HDF5_INCLUDES ${MPI_INCLUDE_PATH})
    endif (MPI_FOUND)
    ## Support for compression
    if (ZLIB_LIBRARIES)
      list (APPEND HDF5_LIBRARIES ${ZLIB_LIBRARIES})
    endif (ZLIB_LIBRARIES)
  else (HDF5_FOUND)
    set (CASACORE_WITH_HDF5 FALSE)
  endif (HDF5_FOUND)
  
endif (CASACORE_WITH_HDF5)

##__________________________________________________________
## Handle option: FFTW3 library support

if (CASACORE_WITH_FFTW3)
  include (FindFFTW3)

  if (NOT FFTW3_FOUND)
    set (CASACORE_WITH_FFTW3 FALSE)
  endif (NOT FFTW3_FOUND)
endif (CASACORE_WITH_FFTW3)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (CASACORE_FROM_REPOS)
  set (CASACORE_FORCE_BUILD TRUE)
endif (CASACORE_FROM_REPOS)

if (NOT CASACORE_FOUND OR CASACORE_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (CASACORE_SOURCE ${CASACORE_SOURCE_ARCHIVE} casacore.tgz
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT CASACORE_SOURCE)
    set (CASACORE_SOURCE ${CASACORE_URL})
  endif (NOT CASACORE_SOURCE)
  
  ## Create configure file for initial cache
  
  configure_file (
    ${PROJECT_SOURCE_DIR}/casacore.cmake.in
    ${PROJECT_BINARY_DIR}/casacore.cmake)
  
  find_file (CASACORE_CMAKE casacore.cmake
    PATHS ${PROJECT_BINARY_DIR}
    )
  
  if (NOT CASACORE_CMAKE)
    message (WARNING "[casacore] Failed to locate initial cache values!")
  endif (NOT CASACORE_CMAKE)
  
  ## Build package from source
  
  if (CASACORE_FROM_REPOS)
    
    ExternalProject_Add (casacore
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${CASACORE_SVN}
      CMAKE_ARGS -C${CASACORE_CMAKE}
      BUILD_COMMAND ${CMAKE_BUILD_TOOL}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (CASACORE_FROM_REPOS)
    
    ExternalProject_Add (casacore
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${CASACORE_SOURCE}
      CMAKE_ARGS -C${CASACORE_CMAKE}
      BUILD_COMMAND ${CMAKE_BUILD_TOOL}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (CASACORE_FROM_REPOS)
  
else (NOT CASACORE_FOUND OR CASACORE_FORCE_BUILD)
  
  add_custom_target (casacore
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[CASACORE] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT CASACORE_FOUND OR CASACORE_FORCE_BUILD)

## ==============================================================================
##
##  Configuration summary
##
## ==============================================================================

if (VERBOSE_CONFIGURE)
  
  message (STATUS "+------------------------------------------------------------+" )
  message (STATUS "| [casacore] Summary of configuration settings               |" )
  message (STATUS "+------------------------------------------------------------+" )
  message (STATUS " CMAKE_SYSTEM             = ${CMAKE_SYSTEM}"            )
  message (STATUS " CMAKE_SYSTEM_PROCESSOR   = ${CMAKE_SYSTEM_PROCESSOR}"  )
  message (STATUS " CMAKE_INSTALL_PREFIX     = ${CMAKE_INSTALL_PREFIX}"    )
  message (STATUS " Found CFITSIO library    = ${CFITSIO_FOUND}"           )
  message (STATUS " .. Library               = ${CFITSIO_LIBRARIES}"       )
  message (STATUS " .. Include directory     = ${CFITSIO_INCLUDES}"        )
  message (STATUS " Found FFTW3 library      = ${FFTW3_FOUND}"             )
  message (STATUS " Found HDF5 library       = ${HDF5_FOUND}"              )
  message (STATUS " .. Library               = ${HDF5_LIBRARIES}"          )
  message (STATUS " .. Include directory     = ${HDF5_INCLUDES}"           )
  message (STATUS " Found LAPACK library     = ${LAPACK_FOUND}"            )
  message (STATUS " Found MPI library        = ${MPI_FOUND}"               )
  message (STATUS " .. Compile flags         = ${MPI_COMPILE_FLAGS}"       )
  message (STATUS " .. Include directory     = ${MPI_INCLUDE_PATH}"        )
  message (STATUS " Found WCSLIB library     = ${WCSLIB_FOUND}"            )
  message (STATUS " .. Library               = ${WCSLIB_LIBRARIES}"        )
  message (STATUS " .. Include directory     = ${WCSLIB_INCLUDES}"         )
  message (STATUS "+------------------------------------------------------------+" )
  
endif (VERBOSE_CONFIGURE)
