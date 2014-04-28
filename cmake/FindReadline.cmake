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

# - Check for the presence of READLINE
#
# The following variables are set when READLINE is found:
#  READLINE_FOUND      = Set to true, if all components of READLINE have been found.
#  READLINE_INCLUDES   = Include path for the header files of READLINE
#  READLINE_LIBRARIES  = Link these to use READLINE
#  READLINE_LFLAGS     = Linker flags (optional)

if (NOT READLINE_FOUND)
    
  if (NOT READLINE_ROOT_DIR)
    set (READLINE_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT READLINE_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (READLINE_INCLUDES readline.h
    HINTS ${READLINE_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES include include/readline
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  ## libreadline

  find_library (READLINE_READLINE_LIBRARY readline
    HINTS ${READLINE_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES lib
    )
  if (READLINE_READLINE_LIBRARY)
    list (APPEND READLINE_LIBRARIES ${READLINE_READLINE_LIBRARY})
  endif (READLINE_READLINE_LIBRARY)

  ## libhistory
  
  find_library (READLINE_HISTORY_LIBRARY history
    HINTS ${READLINE_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES lib
    )
  if (READLINE_HISTORY_LIBRARY)
    list (APPEND READLINE_LIBRARIES ${READLINE_HISTORY_LIBRARY})
  endif (READLINE_HISTORY_LIBRARY)
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (READLINE_INCLUDES AND READLINE_LIBRARIES)
    set (READLINE_FOUND TRUE)
  else (READLINE_INCLUDES AND READLINE_LIBRARIES)
    set (READLINE_FOUND FALSE)
    if (NOT READLINE_FIND_QUIETLY)
      if (NOT READLINE_INCLUDES)
	message (STATUS "Unable to find READLINE header files!")
      endif (NOT READLINE_INCLUDES)
      if (NOT READLINE_LIBRARIES)
	message (STATUS "Unable to find READLINE library files!")
      endif (NOT READLINE_LIBRARIES)
    endif (NOT READLINE_FIND_QUIETLY)
  endif (READLINE_INCLUDES AND READLINE_LIBRARIES)
  
  if (READLINE_FOUND)
    if (NOT READLINE_FIND_QUIETLY)
      message (STATUS "Found components for READLINE")
      message (STATUS "READLINE_ROOT_DIR  = ${READLINE_ROOT_DIR}")
      message (STATUS "READLINE_INCLUDES  = ${READLINE_INCLUDES}")
      message (STATUS "READLINE_LIBRARIES = ${READLINE_LIBRARIES}")
    endif (NOT READLINE_FIND_QUIETLY)
  else (READLINE_FOUND)
    if (READLINE_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find READLINE!")
    endif (READLINE_FIND_REQUIRED)
  endif (READLINE_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    READLINE_INCLUDES
    READLINE_LIBRARIES
    )
  
endif (NOT READLINE_FOUND)
