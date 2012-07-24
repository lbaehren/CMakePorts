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

# - Check for the presence of EXIV2
#
# The following variables are set when EXIV2 is found:
#  EXIV2_FOUND      = Set to true, if all components of EXIV2 have been found.
#  EXIV2_INCLUDES   = Include path for the header files of EXIV2
#  EXIV2_LIBRARIES  = Link these to use EXIV2
#  EXIV2_LFLAGS     = Linker flags (optional)

if (NOT EXIV2_FOUND)
    
  if (NOT EXIV2_ROOT_DIR)
    set (EXIV2_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT EXIV2_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (EXIV2_INCLUDES exiv2.hpp basicio.hpp
    HINTS ${EXIV2_ROOT_DIR}
    PATH_SUFFIXES include exiv2 include/exiv2
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (EXIV2_LIBRARIES exiv2
    HINTS ${EXIV2_ROOT_DIR}
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Check for the executable
  
  find_program (EXIV2_EXECUTABLE exiv2
    HINTS ${EXIV2_ROOT_DIR}
    PATH_SUFFIXES bin
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (EXIV2_INCLUDES AND EXIV2_LIBRARIES)
    set (EXIV2_FOUND TRUE)
  else (EXIV2_INCLUDES AND EXIV2_LIBRARIES)
    set (EXIV2_FOUND FALSE)
    if (NOT EXIV2_FIND_QUIETLY)
      if (NOT EXIV2_INCLUDES)
	message (STATUS "Unable to find EXIV2 header files!")
      endif (NOT EXIV2_INCLUDES)
      if (NOT EXIV2_LIBRARIES)
	message (STATUS "Unable to find EXIV2 library files!")
      endif (NOT EXIV2_LIBRARIES)
    endif (NOT EXIV2_FIND_QUIETLY)
  endif (EXIV2_INCLUDES AND EXIV2_LIBRARIES)
  
  if (EXIV2_FOUND)
    if (NOT EXIV2_FIND_QUIETLY)
      message (STATUS "Found components for EXIV2")
      message (STATUS "EXIV2_ROOT_DIR  = ${EXIV2_ROOT_DIR}")
      message (STATUS "EXIV2_INCLUDES  = ${EXIV2_INCLUDES}")
      message (STATUS "EXIV2_LIBRARIES = ${EXIV2_LIBRARIES}")
    endif (NOT EXIV2_FIND_QUIETLY)
  else (EXIV2_FOUND)
    if (EXIV2_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find EXIV2!")
    endif (EXIV2_FIND_REQUIRED)
  endif (EXIV2_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    EXIV2_INCLUDES
    EXIV2_LIBRARIES
    )
  
endif (NOT EXIV2_FOUND)
