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

# - Check for the presence of FV
#
# The following variables are set when FV is found:
#  FV_FOUND      = Set to true, if all components of FV
#                         have been found.
#  FV_INCLUDES   = Include path for the header files of FV
#  FV_LIBRARIES  = Link these to use FV
#  FV_LFLAGS     = Linker flags (optional)

if (NOT FV_FOUND)
    
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (FV_INCLUDES <header file(s)>
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (FV_LIBRARIES <package name>
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Check for the executable
  
  find_program (FV_EXECUTABLE fv
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES bin
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (FV_INCLUDES AND FV_LIBRARIES)
    set (FV_FOUND TRUE)
  else (FV_INCLUDES AND FV_LIBRARIES)
    set (FV_FOUND FALSE)
    if (NOT FV_FIND_QUIETLY)
      if (NOT FV_INCLUDES)
	message (STATUS "Unable to find FV header files!")
      endif (NOT FV_INCLUDES)
      if (NOT FV_LIBRARIES)
	message (STATUS "Unable to find FV library files!")
      endif (NOT FV_LIBRARIES)
    endif (NOT FV_FIND_QUIETLY)
  endif (FV_INCLUDES AND FV_LIBRARIES)
  
  if (FV_FOUND)
    if (NOT FV_FIND_QUIETLY)
      message (STATUS "Found components for FV")
      message (STATUS "FV_INCLUDES  = ${FV_INCLUDES}")
      message (STATUS "FV_LIBRARIES = ${FV_LIBRARIES}")
    endif (NOT FV_FIND_QUIETLY)
  else (FV_FOUND)
    if (FV_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find FV!")
    endif (FV_FIND_REQUIRED)
  endif (FV_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    FV_INCLUDES
    FV_LIBRARIES
    )
  
endif (NOT FV_FOUND)
