
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (SUBVERSION)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (SUBVERSION_VERSION        "1.7.2" )
set (SUBVERSION_SOURCE_ARCHIVE "subversion-${SUBVERSION_VERSION}.tar.gz" )
set (SUBVERSION_URL            "http://flymed.ru:8080/mirrors/apache/subversion/${SUBVERSION_SOURCE_ARCHIVE}" )
set (SUBVERSION_SVN            "http://svn.apache.org/repos/asf/subversion/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (SUBVERSION_FORCE_BUILD    "Force build and installation of package?" YES )
option (SUBVERSION_FROM_REPOS     "Install package from repository?"         NO )
option (SUBVERSION_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (SUBVERSION_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (SUBVERSION_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindSubversion)
include (FindOpenSSL)
include (FindAPR)

## Extract base directory of APR installation

if (APR_LIBRARIES)
  get_filename_component (APR_LIBRARY_DIR ${APR_LIBRARIES} PATH)
endif (APR_LIBRARIES)

if (APR_LIBRARY_DIR)
  set (APR_PREFIX ${APR_LIBRARY_DIR}/..)
else (APR_LIBRARY_DIR)
  set (APR_PREFIX ${CMAKE_INSTALL_PREFIX})
endif (APR_LIBRARY_DIR)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (SUBVERSION_FROM_REPOS)
  set (SUBVERSION_FORCE_BUILD TRUE)
endif (SUBVERSION_FROM_REPOS)

if (NOT SUBVERSION_FOUND OR SUBVERSION_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (SUBVERSION_SOURCE ${SUBVERSION_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT SUBVERSION_SOURCE)
    set (SUBVERSION_SOURCE ${SUBVERSION_URL})
  endif (NOT SUBVERSION_SOURCE)
  
  ## Build package from source

  set ( ENV{LDFLAGS}  "-L/sw/lib"     )
  set ( ENV{CPPFLAGS} "-I/sw/include" )
  
  if (SUBVERSION_FROM_REPOS)
    
    ExternalProject_Add (subversion
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${SUBVERSION_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-apr=${APR_PREFIX} --with-apr-util=${CMAKE_INSTALL_PREFIX} --with-serf=${CMAKE_INSTALL_PREFIX} --with-neon=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  else (SUBVERSION_FROM_REPOS)
    
    ExternalProject_Add (subversion
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${SUBVERSION_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-apr=${APR_PREFIX} --with-apr-util=${CMAKE_INSTALL_PREFIX} --with-serf=${CMAKE_INSTALL_PREFIX} --with-neon=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
    ExternalProject_Add_Step (subversion subversion_swig
      COMMAND make swig-pl
      COMMAND make check-swig-pl
      COMMAND sudo make install-swig-pl
      COMMENT "Compile Perl modules"
      DEPENDEES build
      DEPENDERS install
      WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/source
      )
    
  endif (SUBVERSION_FROM_REPOS)
  
else (NOT SUBVERSION_FOUND OR SUBVERSION_FORCE_BUILD)
  
  add_custom_target (subversion
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Subversion] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT SUBVERSION_FOUND OR SUBVERSION_FORCE_BUILD)
