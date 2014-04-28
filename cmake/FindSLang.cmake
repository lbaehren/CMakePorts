# +-----------------------------------------------------------------------------+
# |   Copyright (C) 2011                                                        |
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

# - Check for the presence of SLANG
#
# The following variables are set when SLANG is found:
#  SLANG_FOUND      = Set to true, if all components of SLANG have been found.
#  SLANG_INCLUDES   = Include path for the header files of SLANG
#  SLANG_LIBRARIES  = Link these to use SLANG
#  SLANG_LFLAGS     = Linker flags (optional)

if (NOT SLANG_FOUND)
    
  if (NOT SLANG_ROOT_DIR)
    set (SLANG_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT SLANG_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (SLANG_INCLUDES slang.h slcurses.h
    HINTS ${SLANG_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (SLANG_LIBRARIES slang
    HINTS ${SLANG_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Check for the executable
  
  find_program (SLANG_EXECUTABLE slsh
    HINTS ${SLANG_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES bin
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (SLANG_INCLUDES AND SLANG_LIBRARIES)
    set (SLANG_FOUND TRUE)
  else (SLANG_INCLUDES AND SLANG_LIBRARIES)
    set (SLANG_FOUND FALSE)
    if (NOT SLANG_FIND_QUIETLY)
      if (NOT SLANG_INCLUDES)
	message (STATUS "Unable to find SLANG header files!")
      endif (NOT SLANG_INCLUDES)
      if (NOT SLANG_LIBRARIES)
	message (STATUS "Unable to find SLANG library files!")
      endif (NOT SLANG_LIBRARIES)
    endif (NOT SLANG_FIND_QUIETLY)
  endif (SLANG_INCLUDES AND SLANG_LIBRARIES)
  
  if (SLANG_FOUND)
    if (NOT SLANG_FIND_QUIETLY)
      message (STATUS "Found components for SLANG")
      message (STATUS "SLANG_ROOT_DIR  = ${SLANG_ROOT_DIR}")
      message (STATUS "SLANG_INCLUDES  = ${SLANG_INCLUDES}")
      message (STATUS "SLANG_LIBRARIES = ${SLANG_LIBRARIES}")
    endif (NOT SLANG_FIND_QUIETLY)
  else (SLANG_FOUND)
    if (SLANG_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find SLANG!")
    endif (SLANG_FIND_REQUIRED)
  endif (SLANG_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    SLANG_INCLUDES
    SLANG_LIBRARIES
    )
  
endif (NOT SLANG_FOUND)
