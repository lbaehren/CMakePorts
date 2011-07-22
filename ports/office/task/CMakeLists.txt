
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (TASK)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (TASK_VERSION        "1.9.4" )
set (TASK_SOURCE_ARCHIVE "task-${TASK_VERSION}.tar.gz" )
set (TASK_URL            "http://www.taskwarrior.org/download/${TASK_SOURCE_ARCHIVE}" )
set (TASK_GIT            "git://tasktools.org/task.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (TASK_FORCE_BUILD    "Force build and installation of package?" NO )
option (TASK_FROM_REPOS     "Install package from repository?"         NO )
option (TASK_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (TASK_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (TASK_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindTASK)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (TASK_FROM_REPOS)
  set (TASK_FORCE_BUILD TRUE)
endif (TASK_FROM_REPOS)

if (NOT TASK_FOUND OR TASK_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (TASK_SOURCE ${TASK_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT TASK_SOURCE)
    set (TASK_SOURCE ${TASK_URL})
  endif (NOT TASK_SOURCE)
  
  ## Build package from source
  
  if (TASK_FROM_REPOS)
    
    ExternalProject_Add (task
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${TASK_GIT}
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (TASK_FROM_REPOS)
    
    ExternalProject_Add (task
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${TASK_SOURCE}
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (TASK_FROM_REPOS)
  
else (NOT TASK_FOUND OR TASK_FORCE_BUILD)
  
  add_custom_target (task
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[task] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT TASK_FOUND OR TASK_FORCE_BUILD)
