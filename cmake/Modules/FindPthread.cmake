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

# - Check for the presence of PTHREAD
#
# The following variables are set when PTHREAD is found:
#  PTHREAD_FOUND      = Set to true, if all components of PTHREAD have been found.
#  PTHREAD_INCLUDES   = Include path for the header files of PTHREAD
#  PTHREAD_LIBRARIES  = Link these to use PTHREAD
#  PTHREAD_LFLAGS     = Linker flags (optional)

if (NOT PTHREAD_FOUND)
    
  if (NOT PTHREAD_ROOT_DIR)
    set (PTHREAD_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT PTHREAD_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (PTHREAD_INCLUDES pthread.h
    HINTS ${PTHREAD_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (PTHREAD_LIBRARIES pthread
    HINTS ${PTHREAD_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (PTHREAD_INCLUDES AND PTHREAD_LIBRARIES)
    set (PTHREAD_FOUND TRUE)
  else (PTHREAD_INCLUDES AND PTHREAD_LIBRARIES)
    set (PTHREAD_FOUND FALSE)
    if (NOT PTHREAD_FIND_QUIETLY)
      if (NOT PTHREAD_INCLUDES)
	message (STATUS "Unable to find PTHREAD header files!")
      endif (NOT PTHREAD_INCLUDES)
      if (NOT PTHREAD_LIBRARIES)
	message (STATUS "Unable to find PTHREAD library files!")
      endif (NOT PTHREAD_LIBRARIES)
    endif (NOT PTHREAD_FIND_QUIETLY)
  endif (PTHREAD_INCLUDES AND PTHREAD_LIBRARIES)
  
  if (PTHREAD_FOUND)
    if (NOT PTHREAD_FIND_QUIETLY)
      message (STATUS "Found components for PTHREAD")
      message (STATUS "PTHREAD_ROOT_DIR  = ${PTHREAD_ROOT_DIR}")
      message (STATUS "PTHREAD_INCLUDES  = ${PTHREAD_INCLUDES}")
      message (STATUS "PTHREAD_LIBRARIES = ${PTHREAD_LIBRARIES}")
    endif (NOT PTHREAD_FIND_QUIETLY)
  else (PTHREAD_FOUND)
    if (PTHREAD_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find PTHREAD!")
    endif (PTHREAD_FIND_REQUIRED)
  endif (PTHREAD_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    PTHREAD_INCLUDES
    PTHREAD_LIBRARIES
    )
  
endif (NOT PTHREAD_FOUND)
