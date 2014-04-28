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

# - Check for the presence of PTH
#
# The following variables are set when PTH is found:
#  PTH_FOUND      = Set to true, if all components of PTH have been found.
#  PTH_INCLUDES   = Include path for the header files of PTH
#  PTH_LIBRARIES  = Link these to use PTH
#  PTH_LFLAGS     = Linker flags (optional)

if (NOT PTH_FOUND)
    
  if (NOT PTH_ROOT_DIR)
    set (PTH_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT PTH_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (PTH_INCLUDES pth.h
    HINTS ${PTH_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES include include/pth
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (PTH_LIBRARIES pth
    HINTS ${PTH_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Check for the executable
  
  find_program (PTH_CONFIG_EXECUTABLE pth-config
    HINTS ${PTH_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES bin
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (PTH_INCLUDES AND PTH_LIBRARIES)
    set (PTH_FOUND TRUE)
  else (PTH_INCLUDES AND PTH_LIBRARIES)
    set (PTH_FOUND FALSE)
    if (NOT PTH_FIND_QUIETLY)
      if (NOT PTH_INCLUDES)
	message (STATUS "Unable to find PTH header files!")
      endif (NOT PTH_INCLUDES)
      if (NOT PTH_LIBRARIES)
	message (STATUS "Unable to find PTH library files!")
      endif (NOT PTH_LIBRARIES)
    endif (NOT PTH_FIND_QUIETLY)
  endif (PTH_INCLUDES AND PTH_LIBRARIES)
  
  if (PTH_FOUND)
    if (NOT PTH_FIND_QUIETLY)
      message (STATUS "Found components for PTH")
      message (STATUS "PTH_ROOT_DIR          = ${PTH_ROOT_DIR}")
      message (STATUS "PTH_INCLUDES          = ${PTH_INCLUDES}")
      message (STATUS "PTH_LIBRARIES         = ${PTH_LIBRARIES}")
      message (STATUS "PTH_CONFIG_EXECUTABLE = ${PTH_CONFIG_EXECUTABLE}")
    endif (NOT PTH_FIND_QUIETLY)
  else (PTH_FOUND)
    if (PTH_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find PTH!")
    endif (PTH_FIND_REQUIRED)
  endif (PTH_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    PTH_INCLUDES
    PTH_LIBRARIES
    PTH_CONFIG_EXECUTABLE
    )
  
endif (NOT PTH_FOUND)
