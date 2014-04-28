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

# - Check for the presence of LOG4CPLUS
#
# The following variables are set when LOG4CPLUS is found:
#  LOG4CPLUS_FOUND      = Set to true, if all components of LOG4CPLUS
#                         have been found.
#  LOG4CPLUS_INCLUDES   = Include path for the header files of LOG4CPLUS
#  LOG4CPLUS_LIBRARIES  = Link these to use LOG4CPLUS
#  LOG4CPLUS_LFLAGS     = Linker flags (optional)

if (NOT LOG4CPLUS_FOUND)
    
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (LOG4CPLUS_INCLUDES
    NAMES log4cplus/config.hxx log4cplus/appender.h log4cplus/loglevel.h
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (LOG4CPLUS_LIBRARIES log4cplus
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Check for the executable
  
#  find_program (LOG4CPLUS_EXECUTABLE <package name>
#    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
#    PATH_SUFFIXES bin
#    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (LOG4CPLUS_INCLUDES AND LOG4CPLUS_LIBRARIES)
    set (LOG4CPLUS_FOUND TRUE)
  else (LOG4CPLUS_INCLUDES AND LOG4CPLUS_LIBRARIES)
    set (LOG4CPLUS_FOUND FALSE)
    if (NOT LOG4CPLUS_FIND_QUIETLY)
      if (NOT LOG4CPLUS_INCLUDES)
	message (STATUS "Unable to find LOG4CPLUS header files!")
      endif (NOT LOG4CPLUS_INCLUDES)
      if (NOT LOG4CPLUS_LIBRARIES)
	message (STATUS "Unable to find LOG4CPLUS library files!")
      endif (NOT LOG4CPLUS_LIBRARIES)
    endif (NOT LOG4CPLUS_FIND_QUIETLY)
  endif (LOG4CPLUS_INCLUDES AND LOG4CPLUS_LIBRARIES)
  
  if (LOG4CPLUS_FOUND)
    if (NOT LOG4CPLUS_FIND_QUIETLY)
      message (STATUS "Found components for LOG4CPLUS")
      message (STATUS "LOG4CPLUS_INCLUDES  = ${LOG4CPLUS_INCLUDES}")
      message (STATUS "LOG4CPLUS_LIBRARIES = ${LOG4CPLUS_LIBRARIES}")
    endif (NOT LOG4CPLUS_FIND_QUIETLY)
  else (LOG4CPLUS_FOUND)
    if (LOG4CPLUS_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find LOG4CPLUS!")
    endif (LOG4CPLUS_FIND_REQUIRED)
  endif (LOG4CPLUS_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    LOG4CPLUS_INCLUDES
    LOG4CPLUS_LIBRARIES
    )
  
endif (NOT LOG4CPLUS_FOUND)
