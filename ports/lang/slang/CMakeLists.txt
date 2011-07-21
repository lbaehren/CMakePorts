
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (SLANG)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (SLANG_VERSION        "2.2.4" )
set (SLANG_SOURCE_ARCHIVE "slang-${SLANG_VERSION}.tar.gz" )
set (SLANG_URL            "ftp://space.mit.edu/pub/davis/slang/v2.2/${SLANG_SOURCE_ARCHIVE}" )
set (SLANG_SVN            "" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (SLANG_FORCE_BUILD    "Force build and installation of package?" NO )
option (SLANG_FROM_REPOS     "Install package from repository?"         NO )
option (SLANG_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (SLANG_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (SLANG_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## Optional Packages:
##   --with-PACKAGE[=ARG]      use PACKAGE [ARG=yes]
##   --without-PACKAGE         do not use PACKAGE (same as --with-PACKAGE=no)
##   --with-pkgconfigdir=DIR   pkgconfig dir (libdir/pkgconfig)
##   --with-terminfo=xxx       Terminfo layout: default, hpux11, osf1r5, aix4, uwin
##   --with-readline=xxx       use slang(default) or gnu readline for slsh
##   --with-x                  use the X Window System
##   --with-pcre=DIR           Use DIR/lib and DIR/include for pcre
##   --with-pcrelib=DIR        pcre library in DIR
##   --with-pcreinc=DIR        pcre include files in DIR
##   --with-onig=DIR           Use DIR/lib and DIR/include for onig
##   --with-oniglib=DIR        onig library in DIR
##   --with-oniginc=DIR        onig include files in DIR
##   --with-png=DIR            Use DIR/lib and DIR/include for png
##   --with-pnglib=DIR         png library in DIR
##   --with-pnginc=DIR         png include files in DIR
##   --with-z=DIR              Use DIR/lib and DIR/include for z
##   --with-zlib=DIR           z library in DIR
##   --with-zinc=DIR           z include files in DIR
##   --with-iconv=DIR          Use DIR/lib and DIR/include for iconv
##   --with-iconvlib=DIR       iconv library in DIR
##   --with-iconvinc=DIR       iconv include files in DIR
##
## ==============================================================================

include (FindSLang)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (SLANG_FROM_REPOS)
  set (SLANG_FORCE_BUILD TRUE)
endif (SLANG_FROM_REPOS)

if (NOT SLANG_FOUND OR SLANG_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (SLANG_SOURCE ${SLANG_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT SLANG_SOURCE)
    set (SLANG_SOURCE ${SLANG_URL})
  endif (NOT SLANG_SOURCE)
  
  ## Build package from source
  
  if (SLANG_FROM_REPOS)
    
    ExternalProject_Add (slang
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      SVN_REPOSITORY ${SLANG_SVN}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (SLANG_FROM_REPOS)
    
    ExternalProject_Add (slang
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${SLANG_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (SLANG_FROM_REPOS)
  
else (NOT SLANG_FOUND OR SLANG_FORCE_BUILD)
  
  add_custom_target (slang
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[SLANG] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT SLANG_FOUND OR SLANG_FORCE_BUILD)
