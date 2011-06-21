
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (TinyXML)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.6)

## Enforced CMake policy 
cmake_policy (VERSION 2.6)

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (TINYXML_ENABLE_DEBUG
  "DEBUG can be set to YES to include debugging info, or NO otherwise"
  NO
  )

option (TINYXML_ENABLE_PROFILE
  "PROFILE can be set to YES to include profiling info, or NO otherwise"
  NO
  )

option (TINYXML_USE_STL
  "TINYXML_USE_STL can be used to turn on STL support."
  NO
  )

##__________________________________________________________
## Handle option: TINYXML_ENABLE_DEBUG

set (CMAKE_C_FLAGS_RELEASE     "-Wall -Wno-unknown-pragmas -Wno-format -O3" )
set (CMAKE_C_FLAGS_DEBUG       "-Wall -Wno-format -g -DDEBUG" )
set (CMAKE_CXX_FLAGS_RELEASE   "-Wall -Wno-unknown-pragmas -Wno-format -O3" )
set (CMAKE_CXX_FLAGS_DEBUG     "-Wall -Wno-format -g -DDEBUG" )

if (TINYXML_ENABLE_DEBUG)
  set (CMAKE_BUILD_TYPE "Debug")
else (TINYXML_ENABLE_DEBUG)
  set (CMAKE_BUILD_TYPE "Release")
endif (TINYXML_ENABLE_DEBUG)

##__________________________________________________________
## Handle option: TINYXML_ENABLE_PROFILE

if (TINYXML_ENABLE_PROFILE)
  set (CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -pg -O3"   )
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg -O3" )
endif (TINYXML_ENABLE_PROFILE)

##__________________________________________________________
## Handle option: TIXML_USE_STL

if (TIXML_USE_STL)
  add_definitions (-DTIXML_USE_STL)
endif (TIXML_USE_STL)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

## Library

add_library (tinyxml
  tinyxml.cpp
  tinyxmlparser.cpp 
  tinyxmlerror.cpp
  tinystr.cpp
  )

## Test program

add_executable (xmltest
  xmltest.cpp
  )

target_link_libraries (xmltest tinyxml)

if (TINYXML_ENABLE_PROFILE)
  set_target_properties (xmltest
    PROPERTIES
    LINK_FLAGS "${LINK_FLAGS} -pg"
    )
endif (TINYXML_ENABLE_PROFILE)

## ==============================================================================
##
##  Installation instructions
##
## ==============================================================================

install (
  TARGETS tinyxml xmltest
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  )
