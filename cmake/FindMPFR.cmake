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

# - Check for the presence of MPFR
#
# The following variables are set when MPFR is found:
#  MPFR_FOUND       = Set to true, if all components of MPFR
#                          have been found.
#  MPFR_INCLUDES   = Include path for the header files of MPFR
#  MPFR_LIBRARIES  = Link these to use MPFR
#  MPFR_LFLAGS     = Linker flags (optional)

if (NOT MPFR_FOUND)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (MPFR_INCLUDES mpfr.h
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (MPFR_LIBRARIES mpfr
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES lib
    )
  
  if (MPFR_LIBRARIES)
    get_filename_component (MPFR_LIBRARY_DIR ${MPFR_LIBRARIES} PATH)
  endif (MPFR_LIBRARIES)
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (MPFR_INCLUDES AND MPFR_LIBRARIES)
    set (MPFR_FOUND TRUE)
  else (MPFR_INCLUDES AND MPFR_LIBRARIES)
    set (MPFR_FOUND FALSE)
    if (NOT MPFR_FIND_QUIETLY)
      if (NOT MPFR_INCLUDES)
	message (STATUS "Unable to find MPFR header files!")
      endif (NOT MPFR_INCLUDES)
      if (NOT MPFR_LIBRARIES)
	message (STATUS "Unable to find MPFR library files!")
      endif (NOT MPFR_LIBRARIES)
    endif (NOT MPFR_FIND_QUIETLY)
  endif (MPFR_INCLUDES AND MPFR_LIBRARIES)
  
  if (MPFR_FOUND)
    if (NOT MPFR_FIND_QUIETLY)
      message (STATUS "Found components for MPFR")
      message (STATUS "MPFR_INCLUDES  = ${MPFR_INCLUDES}")
      message (STATUS "MPFR_LIBRARIES = ${MPFR_LIBRARIES}")
    endif (NOT MPFR_FIND_QUIETLY)
  else (MPFR_FOUND)
    if (MPFR_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find MPFR!")
    endif (MPFR_FIND_REQUIRED)
  endif (MPFR_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    MPFR_INCLUDES
    MPFR_LIBRARIES
    )
  
endif (NOT MPFR_FOUND)
