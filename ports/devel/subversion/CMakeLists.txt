
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Subversion)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## Package information
set (Subversion_VERSION        "1.6.12" )
set (Subversion_SOURCE_ARCHIVE "subversion-${Subversion_VERSION}.tar.gz" )
set (Subversion_URL            "http://subversion.tigris.org/downloads/${Subversion_SOURCE_ARCHIVE}" )
set (Subversion_SVN            "http://svn.apache.org/repos/asf/subversion/trunk" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Subversion_SVN_INSTALL "Install Subversion from SVN code repository?" FALSE)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindOpenSSL)
include (FindSubversion)

if (NOT APR_FOUND)
  include (FindAPR)
endif (NOT APR_FOUND)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NOT SUBVERSION_FOUND OR SUBVERSION_FORCE_BUILD)
  
  ## Locate source file(s) to build from
  
  find_file (Subversion_SOURCE ${Subversion_SOURCE_ARCHIVE}
    PATHS ${Subversion_SOURCE_DIR}
    )
  
  if (NOT Subversion_SOURCE)
    set (Subversion_SOURCE ${Subversion_URL})
  endif (NOT Subversion_SOURCE)
  
  ## Build package from source
  
  if (Subversion_SVN_INSTALL)
    ExternalProject_Add (subversion
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${Subversion_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
      )
    ## Pre-configure run of autogen
    ExternalProject_Add_Step (subversion subversion_autogen
      COMMAND sh ./autogen.sh
      DEPENDEES patch
      DEPENDERS configure
      WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/source
      )
  else (Subversion_SVN_INSTALL)
    
    ExternalProject_Add (subversion
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${Subversion_SOURCE}
      URL_MD5 ae008ac355581c90494fba86cbfc3413
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-apr=${CMAKE_INSTALL_PREFIX} --with-apr-util=${CMAKE_INSTALL_PREFIX} --with-serf=${CMAKE_INSTALL_PREFIX} --with-neon=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND sudo make install
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
    
  endif (Subversion_SVN_INSTALL)
  
else (NOT SUBVERSION_FOUND OR SUBVERSION_FORCE_BUILD)
  
  add_custom_target (subversion
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Subversion] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT SUBVERSION_FOUND OR SUBVERSION_FORCE_BUILD)
