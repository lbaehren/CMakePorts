# +-----------------------------------------------------------------------------+
# |   Copyright (C) 2011                                                        |
# |   Lars B"ahren (lbaehren@gmail.com)                                         |
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

# - Check for the presence of LIBA52
#
# The following variables are set when LIBA52 is found:
#  LIBA52_FOUND      = Set to true, if all components of LIBA52 have been found.
#  LIBA52_INCLUDES   = Include path for the header files of LIBA52
#  LIBA52_LIBRARIES  = Link these to use LIBA52
#  LIBA52_LFLAGS     = Linker flags (optional)

if (NOT LIBA52_FOUND)
    
  if (NOT LIBA52_ROOT_DIR)
    set (LIBA52_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT LIBA52_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (LIBA52_INCLUDES a52.h audio_out.h
    HINTS ${LIBA52_ROOT_DIR}
    PATH_SUFFIXES include a52dec include/a52dec a52dec/include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (LIBA52_LIBRARIES a52
    HINTS ${LIBA52_ROOT_DIR}
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Check for the executable
  
  find_program (A52DEC_EXECUTABLE a52dec
    HINTS ${LIBA52_ROOT_DIR}
    PATH_SUFFIXES bin
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (LIBA52_INCLUDES AND LIBA52_LIBRARIES)
    set (LIBA52_FOUND TRUE)
  else (LIBA52_INCLUDES AND LIBA52_LIBRARIES)
    set (LIBA52_FOUND FALSE)
    if (NOT LIBA52_FIND_QUIETLY)
      if (NOT LIBA52_INCLUDES)
	message (STATUS "Unable to find LIBA52 header files!")
      endif (NOT LIBA52_INCLUDES)
      if (NOT LIBA52_LIBRARIES)
	message (STATUS "Unable to find LIBA52 library files!")
      endif (NOT LIBA52_LIBRARIES)
    endif (NOT LIBA52_FIND_QUIETLY)
  endif (LIBA52_INCLUDES AND LIBA52_LIBRARIES)
  
  if (LIBA52_FOUND)
    if (NOT LIBA52_FIND_QUIETLY)
      message (STATUS "Found components for LIBA52")
      message (STATUS "LIBA52_ROOT_DIR  = ${LIBA52_ROOT_DIR}")
      message (STATUS "LIBA52_INCLUDES  = ${LIBA52_INCLUDES}")
      message (STATUS "LIBA52_LIBRARIES = ${LIBA52_LIBRARIES}")
    endif (NOT LIBA52_FIND_QUIETLY)
  else (LIBA52_FOUND)
    if (LIBA52_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find LIBA52!")
    endif (LIBA52_FIND_REQUIRED)
  endif (LIBA52_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    LIBA52_INCLUDES
    LIBA52_LIBRARIES
    A52DEC_EXECUTABLE
    )
  
endif (NOT LIBA52_FOUND)
