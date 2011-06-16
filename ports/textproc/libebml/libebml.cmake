
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Libebml)

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

## ==============================================================================
##
##  Project subdirectories
##
## ==============================================================================

include_directories (${PROJECT_SOURCE_DIR})

file (GLOB libebml_sources src/*.cpp)

add_library (libebml ${libebml_sources})

## ==============================================================================
##
##  Installation instructions
##
## ==============================================================================

## Installation of the library

install (
  TARGETS libebml
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  )

## Installation of the header files

install (
  DIRECTORY ebml
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

message (STATUS "+------------------------------------------------------------+")
