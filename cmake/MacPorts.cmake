

##_______________________________________________________________________________
## Check for required tools

find_program (PORT_EXECUTABLE port
  HINTS ${PORT_ROOT_DIR} ${CMAKE_INSTALL_PREFIX} /opt/local
  PATH_SUFFIXES bin
  )

##_______________________________________________________________________________
## Installation of the individual packages

if (PORT_EXECUTABLE)

  add_custom_target (InstallPorts ALL)

  message (STATUS "Checking MacPorts installation ...")
  
  ## List of packages ______________________________________

  foreach (varPackage
      atlas
      bison
      blitz
      boost
      cfitsio
      cmake
      cppunit
      doxygen
      fftw-3
      flex
      ghostscript
      git-core      # +doc+pcre+python27+svn
      graphviz
      gsl
      ilmbase
      libgphoto2
      libxml2
      log4cplus
      ncurses
      neon
      openexr
      openmotif
      openssl
      poppler
      qt4-mac-devel
      readline
      ruby
      rb-rubygems
      sqlite3
      subversion
      szip
      tcl
      tk
      valgrind
      xz
      )
    
    ## Check if package if installed already _______________
    
    execute_process (
      COMMAND ${PORT_EXECUTABLE} installed ${varPackage}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      RESULT_VARIABLE PORT_RESULT_VARIABLE
      OUTPUT_VARIABLE PORT_OUTPUT_VARIABLE
      ERROR_VARIABLE PORT_ERROR_VARIABLE
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )

    string (REGEX MATCH "following" varPortInstalled ${PORT_OUTPUT_VARIABLE})

    ## Installation instructions for the package ___________
    
    if (varPortInstalled)
      message ("   [OK] ${varPackage}")
    else (varPortInstalled)
      message ("   [--] ${varPackage}")
      add_custom_command (
	TARGET InstallPorts
	POST_BUILD
	COMMAND ${PORT_INSTALL_COMMAND} ${PORT_EXECUTABLE} install ${varPackage}
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	COMMENT "Installing MacPorts package ${varPackage} ..."
	)
    endif (varPortInstalled)
    
  endforeach (varPackage)
  
endif (PORT_EXECUTABLE)
