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

# - Check for the presence of MPC
#
# The following variables are set when MPC is found:
#  MPC_FOUND       = Set to true, if all components of MPC have been found.
#  MPC_INCLUDES   = Include path for the header files of MPC
#  MPC_LIBRARIES  = Link these to use MPC
#  MPC_LFLAGS     = Linker flags (optional)

if (NOT MPC_FOUND)
    
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (MPC_INCLUDES mpc.h
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (MPC_LIBRARIES mpc
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (MPC_INCLUDES AND MPC_LIBRARIES)
    set (MPC_FOUND TRUE)
  else (MPC_INCLUDES AND MPC_LIBRARIES)
    set (MPC_FOUND FALSE)
    if (NOT MPC_FIND_QUIETLY)
      if (NOT MPC_INCLUDES)
	message (STATUS "Unable to find MPC header files!")
      endif (NOT MPC_INCLUDES)
      if (NOT MPC_LIBRARIES)
	message (STATUS "Unable to find MPC library files!")
      endif (NOT MPC_LIBRARIES)
    endif (NOT MPC_FIND_QUIETLY)
  endif (MPC_INCLUDES AND MPC_LIBRARIES)
  
  if (MPC_FOUND)
    if (NOT MPC_FIND_QUIETLY)
      message (STATUS "Found components for MPC")
      message (STATUS "MPC_INCLUDES  = ${MPC_INCLUDES}")
      message (STATUS "MPC_LIBRARIES = ${MPC_LIBRARIES}")
    endif (NOT MPC_FIND_QUIETLY)
  else (MPC_FOUND)
    if (MPC_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find MPC!")
    endif (MPC_FIND_REQUIRED)
  endif (MPC_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    MPC_INCLUDES
    MPC_LIBRARIES
    )
  
endif (NOT MPC_FOUND)
