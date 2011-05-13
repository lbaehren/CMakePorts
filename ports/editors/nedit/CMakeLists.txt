
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (NEdit)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (NEdit_VERSION_MAJOR  "5" )
set (NEdit_VERSION_MINOR  "5" )
set (NEdit_VERSION        "${NEdit_VERSION_MAJOR}.${NEdit_VERSION_MINOR}" )
set (NEdit_SOURCE_ARCHIVE "nedit-${NEdit_VERSION}-src.tar.gz" )
set (NEdit_URL            "http://nl.nedit.org/ftp/v${NEdit_VERSION_MAJOR}_${NEdit_VERSION_MINOR}/${NEdit_SOURCE_ARCHIVE}" )
set (NEdit_CVS            ":pserver:anonymous@nedit.cvs.sourceforge.net:" )
set (NEdit_CVS_MODULE     "cvsroot/nedit" )
set (NEdit_GIT            "git://repo.or.cz/nedit.git" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (NEdit_FORCE_BUILD    "Force build and installation of package?" NO )
option (NEdit_FROM_REPOS     "Install package from repository?"         NO )
option (NEdit_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (NEdit_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (NEdit_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_program (NEdit_EXECUTABLE nedit
  PATHS /sw /usr /opt /opt/usr ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES bin local/bin
  )

if (NEdit_EXECUTABLE)
  set (NEDIT_FOUND TRUE)
else (NEdit_EXECUTABLE)
  set (NEDIT_FOUND FALSE)
  include (FindMotif)
endif (NEdit_EXECUTABLE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (NEdit_FROM_REPOS)
  set (NEdit_FORCE_BUILD TRUE)
endif (NEdit_FROM_REPOS)

if (NOT NEDIT_FOUND OR NEdit_FORCE_BUILD)
  
  ## Locate source file to build from
  
  find_file (NEdit_SOURCE ${NEdit_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )
  
  if (NOT NEdit_SOURCE)
    set (NEdit_SOURCE ${NEdit_URL})
  endif (NOT NEdit_SOURCE)
  
  ## Configure the platform-specific Makefile
  
  set (MOTIFDIR ${MOTIF_INCLUDE_DIR})
  set (MOTIFLINK ${MOTIF_LIBRARIES})
  set (EXTRALINKFLAGS "-bind_at_load")

  if (UNIX)
    if (APPLE)
      set (NEdit_PLATFORM "macosx")
    else (APPLE)
      set (NEdit_PLATFORM "linux")
    endif (APPLE)
    set (NEdit_MAKEFILE "Makefile.${NEdit_PLATFORM}")
  endif (UNIX)
  
  configure_file (
    ${PROJECT_SOURCE_DIR}/${NEdit_MAKEFILE}.in
    ${PROJECT_BINARY_DIR}/${NEdit_MAKEFILE}
    )

  ## Build package from source

  if (NEdit_FROM_REPOS OR NOT NEdit_SOURCE)
  
    ## Install from repository checkout
    ExternalProject_Add (nedit
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${NEdit_GIT}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND cp ${PROJECT_BINARY_DIR}/${NEdit_MAKEFILE} ${PROJECT_BINARY_DIR}/source/makefiles
      BUILD_COMMAND make ${NEdit_PLATFORM}
      INSTALL_COMMAND make install
      )
    
  else (NEdit_FROM_REPOS OR NOT NEdit_SOURCE)
    
    ## Install from source tar-archive
    ExternalProject_Add (nedit
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${NEdit_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND cp ${PROJECT_BINARY_DIR}/${NEdit_MAKEFILE} ${PROJECT_BINARY_DIR}/source/makefiles
      BUILD_COMMAND make ${NEdit_PLATFORM}
      INSTALL_COMMAND make install
      )
    
  endif (NEdit_FROM_REPOS OR NOT NEdit_SOURCE)
  
else (NOT NEDIT_FOUND OR NEdit_FORCE_BUILD)
  
  add_custom_target (nedit
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[NEdit] Found system-wide installation; skipping rebuild!"
    )
  
endif (NOT NEDIT_FOUND OR NEdit_FORCE_BUILD)
