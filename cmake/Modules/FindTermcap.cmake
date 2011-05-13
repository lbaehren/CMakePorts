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

# - Check for the presence of TERMCAP
#
# The following variables are set when TERMCAP is found:
#  TERMCAP_FOUND      = Set to true, if all components of TERMCAP
#                         have been found.
#  TERMCAP_INCLUDES   = Include path for the header files of TERMCAP
#  TERMCAP_LIBRARIES  = Link these to use TERMCAP
#  TERMCAP_LFLAGS     = Linker flags (optional)

if (NOT TERMCAP_FOUND)
    
  if (NOT TERMCAP_ROOT_DIR)
    set (TERMCAP_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT TERMCAP_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (TERMCAP_INCLUDES termcap.h
    HINTS ${TERMCAP_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (TERMCAP_LIBRARIES termcap
    HINTS ${TERMCAP_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (TERMCAP_INCLUDES AND TERMCAP_LIBRARIES)
    set (TERMCAP_FOUND TRUE)
  else (TERMCAP_INCLUDES AND TERMCAP_LIBRARIES)
    set (TERMCAP_FOUND FALSE)
    if (NOT TERMCAP_FIND_QUIETLY)
      if (NOT TERMCAP_INCLUDES)
	message (STATUS "Unable to find TERMCAP header files!")
      endif (NOT TERMCAP_INCLUDES)
      if (NOT TERMCAP_LIBRARIES)
	message (STATUS "Unable to find TERMCAP library files!")
      endif (NOT TERMCAP_LIBRARIES)
    endif (NOT TERMCAP_FIND_QUIETLY)
  endif (TERMCAP_INCLUDES AND TERMCAP_LIBRARIES)
  
  if (TERMCAP_FOUND)
    if (NOT TERMCAP_FIND_QUIETLY)
      message (STATUS "Found components for TERMCAP")
      message (STATUS "TERMCAP_ROOT_DIR  = ${TERMCAP_ROOT_DIR}")
      message (STATUS "TERMCAP_INCLUDES  = ${TERMCAP_INCLUDES}")
      message (STATUS "TERMCAP_LIBRARIES = ${TERMCAP_LIBRARIES}")
    endif (NOT TERMCAP_FIND_QUIETLY)
  else (TERMCAP_FOUND)
    if (TERMCAP_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find TERMCAP!")
    endif (TERMCAP_FIND_REQUIRED)
  endif (TERMCAP_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    TERMCAP_INCLUDES
    TERMCAP_LIBRARIES
    )
  
endif (NOT TERMCAP_FOUND)
