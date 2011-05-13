# +-----------------------------------------------------------------------------+
# | $Id::                                                                     $ |
# +-----------------------------------------------------------------------------+
# |   Copyright (C) 2007                                                        |
# |   Lars B"ahren (bahren@astron.nl)                                           |
# |                                                                             |
# |   This program is free software; you can redistribute it and/or modify      |
# |   it under the terms of the GNU General Public License as published by      |
# |   the Free Software Foundation; either version 2 of the License, or         |
# |   (at your option) any later version.                                       |
# |                                                                             |
# |   This program is distributed in the hope that it will be useful,           |
# |   but WITHOUT ANY WARRANTY; without even the implied warranty of            |
# |   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             |
# |   GNU General Public License for more details.                              |
# |                                                                             |
# |   You should have received a copy of the GNU General Public License         |
# |   along with this program; if not, write to the                             |
# |   Free Software Foundation, Inc.,                                           |
# |   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.                 |
# +-----------------------------------------------------------------------------+

# - Check for the presence of BOOST
#
# The following variables are set when BOOST is found:
#  BOOST_FOUND      = Set to true, if all components of BOOST have been found.
#  BOOST_INCLUDES   = Include path for the header files of BOOST
#  BOOST_LIBRARIES  = Link these to use BOOST
#  BOOST_LFLAGS     = Linker flags (optional)

if (NOT BOOST_FOUND)
    
  ##_____________________________________________________________________________
  ## Selection of library components
  
  set (BOOST_WITH_date_time           YES )
  set (BOOST_WITH_filesystem          YES )
  set (BOOST_WITH_iostreams           YES )
  set (BOOST_WITH_program_options     YES )
  set (BOOST_WITH_python              YES )
  set (BOOST_WITH_regex               YES )
  set (BOOST_WITH_serialization       YES )
  set (BOOST_WITH_signals             YES )
  set (BOOST_WITH_system              YES )
  set (BOOST_WITH_thread              YES )
  set (BOOST_WITH_unit_test_framework YES )
  set (BOOST_WITH_wave                YES )
  
  set (_boost_incs boost/config.hpp)
  
  if (BOOST_WITH_date_time)
    list (APPEND _boost_libs boost_date_time)
    list (APPEND _boost_incs boost/date_time.hpp)
  endif (BOOST_WITH_date_time)
  
  if (BOOST_WITH_filesystem)
    list (APPEND _boost_libs boost_filesystem)
    list (APPEND _boost_incs boost/filesystem.hpp)
  endif (BOOST_WITH_filesystem)
  
  if (BOOST_WITH_iostreams)
    list (APPEND _boost_libs boost_iostreams)
  endif (BOOST_WITH_iostreams)
  
  if (BOOST_WITH_program_options)
    list (APPEND _boost_libs boost_program_options)
    list (APPEND _boost_incs boost/program_options.hpp)
  endif (BOOST_WITH_program_options)
  
  if (BOOST_WITH_python)
    list (APPEND _boost_libs boost_python)
    list (APPEND _boost_incs boost/python.hpp)
  endif (BOOST_WITH_python)
  
  if (BOOST_WITH_regex)
    list (APPEND _boost_libs boost_regex)
    list (APPEND _boost_incs boost/regex.hpp)
  endif (BOOST_WITH_regex)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (BOOST_INCLUDES <header file(s)>
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  foreach (_lib ${_boost_libs})

    ## convert library name to upper case
    string(TOUPPER ${_lib} _libName)

    ## locate library
    find_library (${_libName}_LIBRARY ${_lib}
      PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
      PATH_SUFFIXES lib
      )
    
  endforeach (_lib)
  
  ##_____________________________________________________________________________
  ## Check for the executable
  
  find_program (BOOST_EXECUTABLE <package name>
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES bin
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (BOOST_INCLUDES AND BOOST_LIBRARIES)
    set (BOOST_FOUND TRUE)
  else (BOOST_INCLUDES AND BOOST_LIBRARIES)
    set (BOOST_FOUND FALSE)
    if (NOT BOOST_FIND_QUIETLY)
      if (NOT BOOST_INCLUDES)
	message (STATUS "Unable to find BOOST header files!")
      endif (NOT BOOST_INCLUDES)
      if (NOT BOOST_LIBRARIES)
	message (STATUS "Unable to find BOOST library files!")
      endif (NOT BOOST_LIBRARIES)
    endif (NOT BOOST_FIND_QUIETLY)
  endif (BOOST_INCLUDES AND BOOST_LIBRARIES)
  
  if (BOOST_FOUND)
    if (NOT BOOST_FIND_QUIETLY)
      message (STATUS "Found components for BOOST")
      message (STATUS "BOOST_INCLUDES  = ${BOOST_INCLUDES}")
      message (STATUS "BOOST_LIBRARIES = ${BOOST_LIBRARIES}")
    endif (NOT BOOST_FIND_QUIETLY)
  else (BOOST_FOUND)
    if (BOOST_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find BOOST!")
    endif (BOOST_FIND_REQUIRED)
  endif (BOOST_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    BOOST_INCLUDES
    BOOST_LIBRARIES
    )
  
endif (NOT BOOST_FOUND)
