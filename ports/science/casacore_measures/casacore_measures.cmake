
## Name of the project handled by CMake
project (CASACORE_MEASURES)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.6)

## Enforced CMake policy 
cmake_policy (VERSION 2.6)

## Installation instructions

foreach (_data
    ephemerides
    geodetic
    )
  ## install the data sub-directory
  install(
    DIRECTORY ${PROJECT_SOURCE_DIR}/${_data}
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/casacore/data
    )
endforeach (_data)
