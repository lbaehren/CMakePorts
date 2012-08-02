
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (YASM)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (YASM_VERSION        "1.2.0" )
set (YASM_SOURCE_ARCHIVE "yasm-${YASM_VERSION}.tar.gz" )
set (YASM_URL            "http://www.tortall.net/projects/yasm/releases/${YASM_SOURCE_ARCHIVE}" )
set (YASM_SVN            "http://www.tortall.net/svn/yasm/trunk/yasm" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (YASM_FORCE_BUILD    "Force build and installation of package?" NO )
option (YASM_FROM_REPOS     "Install package from repository?"         NO  )
option (YASM_ENABLE_TESTING "Enable testing and experimental builds?"  YES )
option (YASM_ENABLE_CMAKE   "Configure and build using CMake?"         NO  )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindYasm)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (YASM_FROM_REPOS)
  set (YASM_FOUND FALSE)
endif (YASM_FROM_REPOS)

if (NOT YASM_FOUND OR YASM_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (YASM_SOURCE ${YASM_SOURCE_ARCHIVE}
    PATHS ${YASM_SOURCE_DIR}
    )
  
  if (NOT YASM_SOURCE)
    set (YASM_SOURCE ${YASM_URL})
  endif (NOT YASM_SOURCE)
  
  ## Build package from source
  
  if (YASM_FROM_REPOS)
    
    ExternalProject_Add (yasm
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${YASM_SVN}
      CMAKE_ARGS -C${CMakePorts_BINARY_DIR}/configure.cmake -DCMAKE_BUILD_TYPE=Release
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  else (YASM_FROM_REPOS)
    
    if (YASM_ENABLE_CMAKE)
      
      ExternalProject_Add (yasm
	PREFIX ${PROJECT_BINARY_DIR}
	DOWNLOAD_DIR download
	SOURCE_DIR source
	URL ${YASM_SOURCE}
	CMAKE_ARGS -C${CMakePorts_BINARY_DIR}/configure.cmake
	INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
	)
      
    else (YASM_ENABLE_CMAKE)
      
      ExternalProject_Add (yasm
	PREFIX ${PROJECT_BINARY_DIR}
	DOWNLOAD_DIR download
	SOURCE_DIR source
	URL ${YASM_SOURCE}
	CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
	INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
	)
      
    endif(YASM_ENABLE_CMAKE)
    
  endif (YASM_FROM_REPOS)
  
else (NOT YASM_FOUND OR YASM_FORCE_BUILD)
  
  add_custom_target (yasm
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Yasm] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT YASM_FOUND OR YASM_FORCE_BUILD)
