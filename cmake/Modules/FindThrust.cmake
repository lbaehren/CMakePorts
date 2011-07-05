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

# - Check for the presence of THRUST
#
# The following variables are set when THRUST is found:
#  THRUST_FOUND      = Set to true, if all components of THRUST have been found.
#  THRUST_INCLUDES   = Include path for the header files of THRUST

if (NOT THRUST_FOUND)
    
  if (NOT THRUST_ROOT_DIR)
    set (THRUST_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT THRUST_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (THRUST_INCLUDES thrust/host_vector.h thrust/generate.h
    HINTS ${THRUST_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES include cuda/include
    )

  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (THRUST_INCLUDES)
    set (THRUST_FOUND TRUE)
  else (THRUST_INCLUDES)
    set (THRUST_FOUND FALSE)
    if (NOT THRUST_FIND_QUIETLY)
      if (NOT THRUST_INCLUDES)
	message (STATUS "Unable to find THRUST header files!")
      endif (NOT THRUST_INCLUDES)
    endif (NOT THRUST_FIND_QUIETLY)
  endif (THRUST_INCLUDES)
  
  if (THRUST_FOUND)
    if (NOT THRUST_FIND_QUIETLY)
      message (STATUS "Found components for THRUST")
      message (STATUS "THRUST_ROOT_DIR  = ${THRUST_ROOT_DIR}")
      message (STATUS "THRUST_INCLUDES  = ${THRUST_INCLUDES}")
    endif (NOT THRUST_FIND_QUIETLY)
  else (THRUST_FOUND)
    if (THRUST_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find THRUST!")
    endif (THRUST_FIND_REQUIRED)
  endif (THRUST_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    THRUST_INCLUDES
    )
  
endif (NOT THRUST_FOUND)
