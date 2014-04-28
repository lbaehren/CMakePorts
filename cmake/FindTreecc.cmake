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

# - Check for the presence of TREECC
#
# The following variables are set when TREECC is found:
#  TREECC_FOUND     = Set to true, if all components of TREECC have been found.
#  TREECC_LIBRARIES = Link these to use TREECC
#  TREECC_LFLAGS    = Linker flags (optional)

if (NOT TREECC_FOUND)
    
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (TREECC_LIBRARIES treecc
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Check for the executable
  
  find_program (TREECC_EXECUTABLE treecc
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES bin
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (TREECC_EXECUTABLE AND TREECC_LIBRARIES)
    set (TREECC_FOUND TRUE)
  else (TREECC_EXECUTABLE AND TREECC_LIBRARIES)
    set (TREECC_FOUND FALSE)
    if (NOT TREECC_FIND_QUIETLY)
      if (NOT TREECC_EXECUTABLE)
	message (STATUS "Unable to find TREECC executable!")
      endif (NOT TREECC_EXECUTABLE)
      if (NOT TREECC_LIBRARIES)
	message (STATUS "Unable to find TREECC library files!")
      endif (NOT TREECC_LIBRARIES)
    endif (NOT TREECC_FIND_QUIETLY)
  endif (TREECC_EXECUTABLE AND TREECC_LIBRARIES)
  
  if (TREECC_FOUND)
    if (NOT TREECC_FIND_QUIETLY)
      message (STATUS "Found components for TREECC")
      message (STATUS "TREECC_EXECUTABLE = ${TREECC_EXECUTABLE}")
      message (STATUS "TREECC_LIBRARIES  = ${TREECC_LIBRARIES}")
    endif (NOT TREECC_FIND_QUIETLY)
  else (TREECC_FOUND)
    if (TREECC_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find TREECC!")
    endif (TREECC_FIND_REQUIRED)
  endif (TREECC_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    TREECC_EXECUTABLE
    TREECC_LIBRARIES
    )
  
endif (NOT TREECC_FOUND)
