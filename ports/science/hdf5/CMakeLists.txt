
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (HDF5)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (HDF5_VERSION        "1.8.5" )
set (HDF5_SOURCE_ARCHIVE "hdf5-${HDF5_VERSION}.tar.gz" )
set (HDF5_URL            "http://www.hdfgroup.org/ftp/HDF5/prev-releases/hdf5-${HDF5_VERSION}/src/${HDF5_SOURCE_ARCHIVE}" )
#set (HDF5_SVN            "http://svn.hdfgroup.uiuc.edu/hdf5/trunk")
set (HDF5_SVN            "http://svn.hdfgroup.uiuc.edu/hdf5/branches/hdf5_1_8_6")

set (H5CHECK_VERSION        "2_0" )
set (H5CHECK_SOURCE_ARCHIVE "h5check_${H5CHECK_VERSION}.tar.gz" )
set (H5CHECK_URL            "http://www.hdfgroup.org/ftp/HDF5/special_tools/h5check/src/${H5CHECK_SOURCE_ARCHIVE}" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (HDF5_FORCE_BUILD          "Force build and installation of package?" NO  )
option (HDF5_ENABLE_CMAKE         "Build HDF5 using CMake (else Autotools)"  OFF )
option (HDF5_ENABLE_PARALLEL      "Enable parallel build (requires MPI)"     ON  )
option (HDF5_ENABLE_Z_LIB_SUPPORT "Enable Zlib Filters"                      ON  )
option (HDF5_BUILD_TESTING        "Build HDF5 Unit Testing"                  ON  )
option (HDF5_BUILD_EXAMPLES       "Build HDF5 Library Examples"              ON  )
option (BUILD_SHARED_LIBS         "Build Shared Libraries"                   ON  )
option (HDF5_BUILD_CPP_LIB        "Build HDF5 C++ Library"                   ON  )
option (HDF5_BUILD_TOOLS          "Build HDF5 Tools"                         ON  )
option (HDF5_BUILD_HL_LIB         "Build HIGH Level HDF5 Library"            ON  )

option (HDF5_BUILD_STATIC      "Build static version of the library?"      YES )
option (HDF5_ENABLE_FORTRAN    "Compile the Fortran interface?"            NO  )
option (HDF5_ENABLE_PARALLEL   "Search for MPI-IO and MPI support files?"  NO  )
option (HDF5_ENABLE_THREADSAFE "Enable thread safe capability?"            NO  )

## Handle options

if (NOT HDF5_ENABLE_CMAKE)
  
  if (HDF5_BUILD_CPP_LIB)
    set (HDF5_enable_cxx "--enable-cxx") 
  else (HDF5_BUILD_CPP_LIB)
    set (HDF5_enable_cxx "--disable-cxx") 
  endif (HDF5_BUILD_CPP_LIB)
  
  if (HDF5_ENABLE_FORTRAN)
    set (HDF5_enable_fortran "--enable-fortran") 
  else (HDF5_ENABLE_FORTRAN)
    set (HDF5_enable_fortran "--disable-fortran") 
  endif (HDF5_ENABLE_FORTRAN)
  
  if (HDF5_BUILD_HL_LIB)
    set (HDF5_enable_hl "--enable-hl") 
  else (HDF5_BUILD_HL_LIB)
    set (HDF5_enable_hl "--disable-hl") 
  endif (HDF5_BUILD_HL_LIB)
  
  if (BUILD_SHARED_LIBS)
    set (HDF5_enable_shared "--enable-shared") 
  else (BUILD_SHARED_LIBS)
    set (HDF5_enable_shared "--disable-shared") 
  endif (BUILD_SHARED_LIBS)
  
  if (HDF5_BUILD_STATIC)
    set (HDF5_enable_static "--enable-static") 
  else (HDF5_BUILD_STATIC)
    set (HDF5_enable_static "--disable-static") 
  endif (HDF5_BUILD_STATIC)

endif (NOT HDF5_ENABLE_CMAKE)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

## HDF5 library installation

set (HDF5_FIND_QUIETLY YES)
include (FindHDF5)

## Handle option: Enable parallel build (requires MPI)

if (HDF5_ENABLE_PARALLEL)
  ## load CMake module
  set (MPI_FIND_QUIETLY YES)
  include (FindMPI)
  ## check package
  if (NOT MPI_FOUND)
    set (HDF5_ENABLE_PARALLEL OFF)
  endif (NOT MPI_FOUND)
endif (HDF5_ENABLE_PARALLEL)

## Handle option: Enable Zlib Filters

if (HDF5_ENABLE_Z_LIB_SUPPORT)
  ## load CMake module
  include (FindZLIB)
  ## check package
  if (NOT ZLIB_FOUND)
    set (HDF5_ENABLE_Z_LIB_SUPPORT OFF)
  endif (NOT ZLIB_FOUND)
endif (HDF5_ENABLE_Z_LIB_SUPPORT)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NOT HDF5_FOUND OR HDF5_FORCE_BUILD)

  ## Initial cache

  configure_file (
    ${HDF5_SOURCE_DIR}/hdf5.cmake
    ${HDF5_BINARY_DIR}/hdf5.cmake
    )
  
  ## Locate source file to build from
  
  find_file (HAVE_HDF5_SOURCE ${HDF5_SOURCE_ARCHIVE}
    PATHS ${HDF5_SOURCE_DIR}
    )
  
  if (NOT HAVE_HDF5_SOURCE)
    set (HAVE_HDF5_SOURCE ${HDF5_URL})
  endif (NOT HAVE_HDF5_SOURCE)
  
  ## Build package from source
  
  if (HDF5_ENABLE_CMAKE)
    
    ExternalProject_Add (hdf5
      PREFIX ${HDF5_BINARY_DIR}
      DOWNLOAD_DIR ${HDF5_BINARY_DIR}/download
      SOURCE_DIR ${HDF5_BINARY_DIR}/source
      URL ${HAVE_HDF5_SOURCE}
      CMAKE_ARGS -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} -C ${HDF5_BINARY_DIR}/hdf5.cmake
      INSTALL_COMMAND sudo make install
      )
    
  else (HDF5_ENABLE_CMAKE)
    
    ExternalProject_Add (hdf5
      PREFIX ${HDF5_BINARY_DIR}
      DOWNLOAD_DIR ${HDF5_BINARY_DIR}/download
      SOURCE_DIR ${HDF5_BINARY_DIR}/source
      URL ${HAVE_HDF5_SOURCE}
      CONFIGURE_COMMAND ${HDF5_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --bindir=${CMAKE_INSTALL_PREFIX}/bin --includedir=${CMAKE_INSTALL_PREFIX}/include/hdf5 ${HDF5_enable_cxx} ${HDF5_enable_fortran} ${HDF5_enable_hl} ${HDF5_enable_shared} ${HDF5_enable_static}
      INSTALL_COMMAND sudo make install
      )

  endif (HDF5_ENABLE_CMAKE)
  
else (NOT HDF5_FOUND OR HDF5_FORCE_BUILD)
  
  add_custom_target (hdf5
    WORKING_DIRECTORY ${HDF5_BINARY_DIR}
    COMMENT "[HDF5] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT HDF5_FOUND OR HDF5_FORCE_BUILD)

## === h5check tool ==================================================

if (NOT H5CHECK_EXECUTABLE)

  ExternalProject_Add (h5check
    PREFIX ${HDF5_BINARY_DIR}
    DOWNLOAD_DIR h5check_download
    SOURCE_DIR h5check_source
    URL ${H5CHECK_URL}
    CONFIGURE_COMMAND ${HDF5_BINARY_DIR}/h5check_source/configure --prefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )

endif (NOT H5CHECK_EXECUTABLE)

## ==============================================================================
##
##  Configuration summary
##
## ==============================================================================

if (VERBOSE_CONFIGURE)

  message ("")
  message (STATUS "+------------------------------------------------------------+")
  
  message (STATUS "[HDF5] Configuration summary.")
  message (STATUS "CMake installation area                 = ${CMAKE_INSTALL_PREFIX}" )
  message (STATUS "Force build and installation of package = ${HDF5_FORCE_BUILD}"     )
  message (STATUS "Build HDF5 using CMake (else Autotools) = ${HDF5_ENABLE_CMAKE}"    )
  message (STATUS "Enable parallel build (requires MPI)    = ${HDF5_ENABLE_PARALLEL}" )
  message (STATUS "Build HDF5 Unit Testing                 = ${HDF5_BUILD_TESTING}"   )
  message (STATUS "Build HDF5 Library Examples             = ${HDF5_BUILD_EXAMPLES}"  )
  message (STATUS "Build HDF5 C++ Library                  = ${HDF5_BUILD_CPP_LIB}"   )
  message (STATUS "Build HDF5 Tools                        = ${HDF5_BUILD_TOOLS}"     )
  message (STATUS "Build HIGH Level HDF5 Library           = ${HDF5_BUILD_HL_LIB}"    )
  
  message (STATUS "+------------------------------------------------------------+")
  message ("")
  
endif (VERBOSE_CONFIGURE)