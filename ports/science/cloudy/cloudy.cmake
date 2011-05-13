
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (CLOUDY CXX)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

##_______________________________________________________________________________
##                                                            Library (libcloudy)

file (GLOB cloudy_sources ${PROJECT_SOURCE_DIR}/source/*.cpp)

if (cloudy_sources)

  ## compiler flags
  add_definitions (
    -O3
    -ftrapping-math
    -fno-math-errno
    )

  ## compiler instructions
  add_library (cloudy ${cloudy_sources})

else (cloudy_sources)
  
  message (WARNING "Unable to build libcloudy - missing sources!")
  
endif (cloudy_sources)

##_______________________________________________________________________________
##                                              Main application program (maincl)

add_executable (maincl ${PROJECT_SOURCE_DIR}/source/maincl.cpp)

target_link_libraries (maincl cloudy)

## ==============================================================================
##
##  Installation instructions
##
## ==============================================================================

install (
  TARGETS cloudy maincl
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  )

## ==============================================================================
##
##  Configuration summary
##
## ==============================================================================

message (STATUS "[Cloudy] Configuration summary.")
message (STATUS " CMAKE_INSTALL_PREFIX = ${CMAKE_INSTALL_PREFIX}")
