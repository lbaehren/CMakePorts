
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (GIT)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (GIT_VERSION        "1.7.5.1")
set (GIT_SOURCE_ARCHIVE "git-${GIT_VERSION}.tar.gz")
set (GIT_URL            "http://kernel.org/pub/software/scm/git/${GIT_SOURCE_ARCHIVE}")
set (GIT_GIT            "git://github.com/git/git.git")

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (GIT_FORCE_BUILD       "Force build and installation of package?"  NO  )
option (GIT_FROM_REPOS        "Install package from repository?"          NO  )
option (GIT_ENABLE_TESTING    "Enable testing and experimental builds?"   YES )
option (GIT_VERBOSE_CONFIGURE "Be verbose during configugration?"         NO  )
option (GIT_WITH_CURL         "Support for http(s):// transports?"        YES )
option (GIT_WITH_EXPAT        "Support git-push transports via WebDAV?"   YES )
option (GIT_WITH_ZLIB         "Support for zlib compression?"             YES )

## Handle options

if (GIT_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (GIT_ENABLE_TESTING)

if (GIT_WITH_CURL)
  include (FindCURL)
endif (GIT_WITH_CURL)

if (GIT_WITH_EXPAT)
  include (FindEXPAT)
endif (GIT_WITH_EXPAT)

if (GIT_WITH_ZLIB)
  include (FindZLIB)
endif (GIT_WITH_ZLIB)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindGit)
include (FindIconv)
include (FindOpenSSL)
include (FindPerlLibs)

find_program (asciidoc_executable asciidoc ${bin_locations})

#  --with-openssl          use OpenSSL library (default is YES)
#                          ARG can be prefix for openssl library and headers
#  --with-curl             support http(s):// transports (default is YES)
#                          ARG can be also prefix for curl library and headers
#  --with-expat            support git-push using http:// and https://
#                          transports via WebDAV (default is YES)
#                          ARG can be also prefix for expat library and headers
#  --with-iconv=PATH       PATH is prefix for libiconv library and headers
#                          used only if you need linking with libiconv

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (GIT_FROM_REPOS)
  set (GIT_FORCE_BUILD TRUE)
endif (GIT_FROM_REPOS)

if (NOT GIT_FOUND OR GIT_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (GIT_SOURCE ${GIT_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT GIT_SOURCE)
    set (GIT_SOURCE ${GIT_URL})
  endif (NOT GIT_SOURCE)
  
  ## Build package from source
  
  if (GIT_FROM_REPOS)
    
    ExternalProject_Add (git
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${GIT_GIT}
      BUILD_IN_SOURCE 1
      PATCH_COMMAND ${PROJECT_BINARY_DIR}/source/make configure
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-curl=${CMAKE_INSTALL_PREFIX} --with-expat=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
  
  else (GIT_FROM_REPOS)
    
    ExternalProject_Add (git
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${GIT_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${PROJECT_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX} --with-curl=${CMAKE_INSTALL_PREFIX} --with-expat=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )
    
  endif (GIT_FROM_REPOS)

  ## Post installation instructions
  
  # git config --global user.name "Lars Baehren"
  # git config --global user.email lbaehren@gmail.com
  # git config --global color.diff auto
  # git config --global color.status auto
  # git config --global color.branch auto
  
else (NOT GIT_FOUND OR GIT_FORCE_BUILD)
  
  add_custom_target (git
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[Git] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT GIT_FOUND OR GIT_FORCE_BUILD)

