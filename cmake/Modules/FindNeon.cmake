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

# - Check for the presence of NEON
#
# The following variables are set when NEON is found:
#  NEON_FOUND       = Set to true, if all components of NEON have been found.
#  NEON_INCLUDES   = Include path for the header files of NEON
#  NEON_LIBRARIES  = Link these to use NEON
#  NEON_LFLAGS     = Linker flags (optional)

if (NOT FIND_NEON_CMAKE)
  
  set (FIND_NEON_CMAKE TRUE)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (NEON_INCLUDES neon.h
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (NEON_LIBRARIES neon
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (NEON_INCLUDES AND NEON_LIBRARIES)
    set (NEON_FOUND TRUE)
  else (NEON_INCLUDES AND NEON_LIBRARIES)
    set (NEON_FOUND FALSE)
    if (NOT NEON_FIND_QUIETLY)
      if (NOT NEON_INCLUDES)
	message (STATUS "Unable to find NEON header files!")
      endif (NOT NEON_INCLUDES)
      if (NOT NEON_LIBRARIES)
	message (STATUS "Unable to find NEON library files!")
      endif (NOT NEON_LIBRARIES)
    endif (NOT NEON_FIND_QUIETLY)
  endif (NEON_INCLUDES AND NEON_LIBRARIES)
  
  if (NEON_FOUND)
    if (NOT NEON_FIND_QUIETLY)
      message (STATUS "Found components for NEON")
      message (STATUS "NEON_INCLUDES  = ${NEON_INCLUDES}")
      message (STATUS "NEON_LIBRARIES = ${NEON_LIBRARIES}")
    endif (NOT NEON_FIND_QUIETLY)
  else (NEON_FOUND)
    if (NEON_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find NEON!")
    endif (NEON_FIND_REQUIRED)
  endif (NEON_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    NEON_INCLUDES
    NEON_LIBRARIES
    )
  
endif (NOT FIND_NEON_CMAKE)
