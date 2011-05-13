
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Perl)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (Perl_VERSION        "5.12.1" )
set (Perl_SOURCE_ARCHIVE "perl-${Perl_VERSION}.tar.gz" )
set (Perl_URL            "http://www.cpan.org/src/${Perl_SOURCE_ARCHIVE}" )
set (Perl_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Perl_FORCE_BUILD    "Force build and installation of package?" NO )
option (Perl_FROM_REPOS     "Install package from repository?"         NO )
option (Perl_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (Perl_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (Perl_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindPerl)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (Perl_FROM_REPOS)
  set (Perl_FORCE_BUILD TRUE)
endif (Perl_FROM_REPOS)

if (NOT HAVE_Perl OR Perl_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (Perl_SOURCE ${Perl_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT Perl_SOURCE)
    set (Perl_SOURCE ${Perl_URL})
  endif (NOT Perl_SOURCE)
  
  ## Build package from source
  
  ExternalProject_Add (perl
    PREFIX ${PROJECT_BINARY_DIR}
    DOWNLOAD_DIR download
    SOURCE_DIR source
    URL ${Perl_SOURCE}
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/Configure -des -Dprefix=${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND sudo make install
    )
  
else (NOT HAVE_Perl OR Perl_FORCE_BUILD)
  
  add_custom_target (perl
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Perl] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT HAVE_Perl OR Perl_FORCE_BUILD)
