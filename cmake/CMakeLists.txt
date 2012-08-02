
## Check platform before including module

if (APPLE)
  include (${CMAKE_CURRENT_SOURCE_DIR}/MacPorts.cmake)
endif (APPLE)
