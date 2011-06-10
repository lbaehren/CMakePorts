
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Gnuplot)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##  Package information
set (Gnuplot_VERSION        "4.4.3" )
set (Gnuplot_SOURCE_ARCHIVE "gnuplot-${Gnuplot_VERSION}.tar.gz" )
set (Gnuplot_URL            "http://ignum.dl.sourceforge.net/project/gnuplot/gnuplot/${Gnuplot_VERSION}/${Gnuplot_SOURCE_ARCHIVE}" )
set (Gnuplot_CVS            ":pserver:anonymous@gnuplot.cvs.sourceforge.net:/cvsroot/gnuplot" )

## ==============================================================================
##
##  Options
##
## ==============================================================================

option (Gnuplot_FORCE_BUILD    "Force build and installation of package?" NO  )
option (Gnuplot_FROM_REPOS     "Install package from repository?"         NO  )
option (Gnuplot_ENABLE_TESTING "Enable testing and experimental builds?"  YES )

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

find_program (GNUPLOT_EXECUTABLE gnuplot
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES bin
  )

if (GNUPLOT_EXECUTABLE)
  set (GNUPLOT_FOUND TRUE)
endif (GNUPLOT_EXECUTABLE)

## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

if (Gnuplot_FROM_REPOS)
  set (Gnuplot_FORCE_BUILD TRUE)
endif (Gnuplot_FROM_REPOS)

if (Gnuplot_FORCE_BUILD OR NOT GNUPLOT_FOUND)
  
  ## Locate source file to build from
  
  find_file (HAVE_Gnuplot_SOURCE ${Gnuplot_SOURCE_ARCHIVE}
    PATHS ${Gnuplot_SOURCE_DIR}
    )
  
  if (NOT HAVE_Gnuplot_SOURCE)
    set (HAVE_Gnuplot_SOURCE ${Gnuplot_URL})
  endif (NOT HAVE_Gnuplot_SOURCE)
  
  ## Build package from source
  
  if (Gnuplot_FROM_REPOS)
    
    ExternalProject_Add (gnuplot
      PREFIX ${Gnuplot_BINARY_DIR}
      DOWNLOAD_DIR ${Gnuplot_BINARY_DIR}/download
      SOURCE_DIR ${Gnuplot_BINARY_DIR}/source
      CVS_REPOSITORY ${Gnuplot_CVS}
      CVS_MODULE gnuplot
      BUILD_IN_SOURCE 1
      PATCH_COMMAND ${Gnuplot_BINARY_DIR}/source/prepare
      CONFIGURE_COMMAND ${Gnuplot_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}  --without-lisp-files
      INSTALL_COMMAND sudo make install
      )
    
  else (Gnuplot_FROM_REPOS)
    
    ExternalProject_Add (gnuplot
      PREFIX ${Gnuplot_BINARY_DIR}
      DOWNLOAD_DIR ${Gnuplot_BINARY_DIR}/download
      SOURCE_DIR ${Gnuplot_BINARY_DIR}/source
      URL ${HAVE_Gnuplot_SOURCE}
      BUILD_IN_SOURCE 1
      CONFIGURE_COMMAND ${Gnuplot_BINARY_DIR}/source/configure --prefix=${CMAKE_INSTALL_PREFIX}  --without-lisp-files
      INSTALL_COMMAND sudo make install
      )
    
  endif (Gnuplot_FROM_REPOS)
  
else (Gnuplot_FORCE_BUILD OR NOT GNUPLOT_FOUND)
  
  add_custom_target (gnuplot
    WORKING_DIRECTORY ${Gnuplot_BINARY_DIR}
    COMMENT "[Gnuplot] Found system-wide installation; skipping rebuild!"
    )
  
endif (Gnuplot_FORCE_BUILD OR NOT GNUPLOT_FOUND)
