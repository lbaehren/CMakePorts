
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CBLAS Fortran C)

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
##  System inspection
##
## ==============================================================================


## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

## Set include directories

include_directories (src)

## Find source files

FILE (GLOB cblas_sources src/*.f src/*.c)

## Compiler instructions

add_library (cblas ${cblas_sources})

## Installation instructions

install (
  TARGETS cblas
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  )
