
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (TELLICO)

## CMake policy (https://cmake.org/Wiki/CMake_Policies)
cmake_policy (VERSION 2.8)

if (POLICY CMP0042)
    cmake_policy (SET CMP0042 NEW)
endif (POLICY CMP0042)

##  Package information
set (TELLICO_VERSION        "2.3.4" )
set (TELLICO_SOURCE_ARCHIVE "tellico-${TELLICO_VERSION}.tar.bz2" )
set (TELLICO_URL            "http://tellico-project.org/files/${TELLICO_SOURCE_ARCHIVE}" )
set (TELLICO_GIT            "git://anongit.kde.org/tellico" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (TELLICO_FORCE_BUILD    "Force build and installation of package?" NO )
option (TELLICO_FROM_REPOS     "Install package from repository?"         NO )
option (TELLICO_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## Handle options

if (TELLICO_ENABLE_TESTING)
  include (CTest)
  enable_testing()
endif (TELLICO_ENABLE_TESTING)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

#include (FindTellico)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (TELLICO_FROM_REPOS)
  set (TELLICO_FORCE_BUILD TRUE)
endif (TELLICO_FROM_REPOS)

if (NOT TELLICO_FOUND OR TELLICO_FORCE_BUILD)

  ## Locate source file to build from

  find_file (TELLICO_SOURCE ${TELLICO_SOURCE_ARCHIVE}
    PATHS ${PROJECT_SOURCE_DIR}
    )

  if (NOT TELLICO_SOURCE)
    set (TELLICO_SOURCE ${TELLICO_URL})
  endif (NOT TELLICO_SOURCE)

  ## Build package from source

  if (TELLICO_FROM_REPOS)

    ExternalProject_Add (tellico
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      GIT_REPOSITORY ${TELLICO_GIT}
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  else (TELLICO_FROM_REPOS)

    ExternalProject_Add (tellico
      PREFIX ${PROJECT_BINARY_DIR}
      DOWNLOAD_DIR download
      SOURCE_DIR source
      URL ${TELLICO_SOURCE}
      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      INSTALL_COMMAND ${PORT_INSTALL_COMMAND} make install
      )

  endif (TELLICO_FROM_REPOS)

  ExternalProject_Add_Step(tellico tellico_ports
    COMMAND ${PORT_INSTALL_COMMAND} port install kde4-baseapps kdemultimedia4 libksane taglib exempi yaz libxslt poppler
    COMMENT "Installing required MacPorts packages ..."
    DEPENDEES download
    DEPENDERS configure
    )

else (NOT TELLICO_FOUND OR TELLICO_FORCE_BUILD)

  add_custom_target (tellico
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    COMMENT "[tellico] Found system-wide installation; skipping rebuild!"
    )

endif (NOT TELLICO_FOUND OR TELLICO_FORCE_BUILD)
