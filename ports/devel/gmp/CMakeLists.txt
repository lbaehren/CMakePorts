
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (GMP)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (GMP_VERSION        "5.0.1" )
set (GMP_SOURCE_ARCHIVE "gmp-${GMP_VERSION}.tar.gz" )
set (GMP_URL            "ftp://ftp.gmplib.org/pub/gmp-${GMP_VERSION}/${GMP_SOURCE_ARCHIVE}" )
set (GMP_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (GMP_FORCE_BUILD    "Force build and installation of package?" NO )
option (GMP_FROM_REPOS     "Install package from repository?"         NO )
option (GMP_ENABLE_TESTING "Enable testing and experimental builds?"  YES )
option (GMP_ENABLE_MPBSD   "Build Berkeley MP compatibility library?" YES )
option (GMP_ENABLE_FFT     "Enable FFTs for multiplication?"          YES )

## Handle options

if (GMP_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (GMP_ENABLE_TESTING)

if (GMP_ENABLE_MPBSD)
  set (enable_mpbsd "--enable-mpbsd")
else (GMP_ENABLE_MPBSD)
  set (enable_mpbsd "--disable-mpbsd")
endif (GMP_ENABLE_MPBSD)

if (GMP_ENABLE_FFT)
  set (enable_fft "--enable-fft")
else (GMP_ENABLE_FFT)
  set (enable_fft "--disable-fft")
endif (GMP_ENABLE_FFT)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

set (GMP_FIND_QUIETLY YES)

if (NOT GMP_FOUND)
  include (FindGMP)
endif (NOT GMP_FOUND)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NOT GMP_FOUND OR GMP_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (GMP_SOURCE ${GMP_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT GMP_SOURCE)
    set (GMP_SOURCE ${GMP_URL})
  endif (NOT GMP_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (gmp
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR ${PROJECT_BINARY_DIR}/download
    SOURCE_DIR ${PROJECT_BINARY_DIR}/source
    URL ${GMP_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-cxx ${enable_mpbsd} ${enable_fft}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT GMP_FOUND OR GMP_FORCE_BUILD)
  
  add_custom_target (gmp
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[GMP] Found system-wide installation; skipping rebuild!"
    )

  message (STATUS " GMP includes  = ${GMP_INCLUDES}")
  message (STATUS " GMP libraries = ${GMP_LIBRARIES}")
  
endif (NOT GMP_FOUND OR GMP_FORCE_BUILD)

## ==============================================================================
##
##  Configuration summary
##
## ==============================================================================

message (STATUS "+------------------------------------------------------------+")

message (STATUS "[GMP] Configuration summary")
message (STATUS " GMP version            = ${GMP_VERSION}"            )
message (STATUS " CMAKE_INSTALL_PREFIX   = ${CMAKE_INSTALL_PREFIX}"   )
message (STATUS " CMAKE_SYSTEM_PROCESSOR = ${CMAKE_SYSTEM_PROCESSOR}" )
message (STATUS " CMAKE_SYSTEM_NAME      = ${CMAKE_SYSTEM_NAME}"      )
message (STATUS " CMAKE_SYSTEM_VERSION   = ${CMAKE_SYSTEM_VERSION}"   )
message (STATUS " CMAKE_C_COMPILER       = ${CMAKE_C_COMPILER}"       )
message (STATUS " CMAKE_CXX_COMPILER     = ${CMAKE_CXX_COMPILER}"     )

message (STATUS "+------------------------------------------------------------+")

