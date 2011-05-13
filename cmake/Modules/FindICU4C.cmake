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

# - Check for the presence of ICU4C
#
# The following variables are set when ICU4C is found:
#  ICU4C_FOUND       = Set to true, if all components of ICU4C
#                          have been found.
#  ICU4C_INCLUDES   = Include path for the header files of ICU4C
#  ICU4C_LIBRARIES  = Link these to use ICU4C
#  ICU4C_LFLAGS     = Linker flags (optional)

if (NOT FIND_ICU4C_CMAKE)
  
  set (FIND_ICU4C_CMAKE TRUE)
  
  ##_____________________________________________________________________________
  ## Check for configuration tool

  find_program (ICU_CONFIG icu-config
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES bin
    )

  ## If configuration tool is available, retrieve further package information

  if (ICU_CONFIG)
    execute_process (
      COMMAND ${ICU_CONFIG} --version
      OUTPUT_VARIABLE ICU4C_VERSION
      )
  endif (ICU_CONFIG)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (ICU4C_INCLUDES unicode/timezone.h unicode/errorcode
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library

  foreach (_lib 
      icuuc
      icutest
      iculx
      icule
      icuio
      icudata
      )
    
    string (TOUPPER ${_lib} _var)

    find_library (ICU4C_${_var}_LIBRARY ${_lib}
      PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
      PATH_SUFFIXES lib
      )

    if (ICU4C_${_var}_LIBRARY)
      list (APPEND ICU4C_LIBRARIES ${ICU4C_${_var}_LIBRARY})
      mark_as_advanced (ICU4C_${_var}_LIBRARY)
    endif (ICU4C_${_var}_LIBRARY)
    
  endforeach (_lib)
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (ICU4C_INCLUDES AND ICU4C_LIBRARIES)
    set (ICU4C_FOUND TRUE)
  else (ICU4C_INCLUDES AND ICU4C_LIBRARIES)
    set (ICU4C_FOUND FALSE)
    if (NOT ICU4C_FIND_QUIETLY)
      if (NOT ICU4C_INCLUDES)
	message (STATUS "Unable to find ICU4C header files!")
      endif (NOT ICU4C_INCLUDES)
      if (NOT ICU4C_LIBRARIES)
	message (STATUS "Unable to find ICU4C library files!")
      endif (NOT ICU4C_LIBRARIES)
    endif (NOT ICU4C_FIND_QUIETLY)
  endif (ICU4C_INCLUDES AND ICU4C_LIBRARIES)
  
  if (ICU4C_FOUND)
    if (NOT ICU4C_FIND_QUIETLY)
      message (STATUS "Found components for ICU4C")
      message (STATUS "ICU4C_INCLUDES  = ${ICU4C_INCLUDES}")
      message (STATUS "ICU4C_LIBRARIES = ${ICU4C_LIBRARIES}")
    endif (NOT ICU4C_FIND_QUIETLY)
  else (ICU4C_FOUND)
    if (ICU4C_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find ICU4C!")
    endif (ICU4C_FIND_REQUIRED)
  endif (ICU4C_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    ICU4C_INCLUDES
    ICU4C_LIBRARIES
    )
  
endif (NOT FIND_ICU4C_CMAKE)
