
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Libmatroska)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.6)

## Enforced CMake policy 
cmake_policy (VERSION 2.6)

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (ENABLE_CTEST         "Enable testing? (CTest)"                    YES )
option (ENABLE_CPACK         "Enable packaging driver? (CPack)"           YES )
option (VERBOSE_CONFIGURE    "Be verbose during configuration stage?"     NO  )

##____________________________________________________________________
##                                                 Handling of options

## Enable testing

if (ENABLE_CTEST)
  ## include the required module
  include (CTest)
  ## enable testing
  enable_testing()
endif (ENABLE_CTEST)

## Enable packaging driver

if (ENABLE_CPACK)
  include (CPack)
endif (ENABLE_CPACK)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

if (WIN32)
  add_definitions (-DWIN32)
endif (WIN32)

## Find components of libebml installation

find_path (LIBEBML_INCLUDES ebml/Debug.h ebml/EbmlConfig.h
  HINTS ${LIBEBML_ROOT_DIR}
  PATHS /sw /usr /usr/local /opt/local
  PATH_SUFFIXES include
  )

find_library (LIBEBML_LIBRARIES ebml
  HINTS ${LIBEBML_ROOT_DIR}
  PATHS /sw /usr /usr/local /opt/local
  PATH_SUFFIXES lib
  )

if (NOT LIBEBML_INCLUDES)
  message (ERROR "[LibMatroska] Missing libebml header files!")
endif (NOT LIBEBML_INCLUDES)

if (NOT LIBEBML_LIBRARIES)
  message (ERROR "[LibMatroska] Missing libebml library!")
endif (NOT LIBEBML_LIBRARIES)

## ==============================================================================
##
##  Project subdirectories
##
## ==============================================================================

include_directories (
  ${PROJECT_SOURCE_DIR}
  ${LIBEBML_INCLUDES}
  )

file (GLOB libmatroska_sources src/*.cpp)

## Compiler instructions
add_library (matroska ${libmatroska_sources})

## Linker instructions
target_link_libraries (matroska ${LIBEBML_LIBRARIES})

## ==============================================================================
##
##  Installation instructions
##
## ==============================================================================

## Installation of the library

install (
  TARGETS matroska
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  )

## Installation of the header files

install (
  DIRECTORY matroska
  DESTINATION ${CMAKE_INSTALL_PREFIX}/include
  )


## ==============================================================================
##
##  Configuration summary
##
## ==============================================================================

message (STATUS "+------------------------------------------------------------+")

message (STATUS "PROJECT_NAME           = ${PROJECT_NAME}")
message (STATUS "CMAKE_SYSTEM           = ${CMAKE_SYSTEM}")
message (STATUS "CMAKE_SYSTEM_PROCESSOR = ${CMAKE_SYSTEM_PROCESSOR}")
message (STATUS "libebml include dir    = ${LIBEBML_INCLUDES}")
message (STATUS "libebml library        = ${LIBEBML_LIBRARIES}")


message (STATUS "+------------------------------------------------------------+")
