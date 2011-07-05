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

# - Check for the presence of APR
#
# The following variables are set when APR is found:
#  APR_FOUND       = Set to true, if all components of APR
#                          have been found.
#  APR_INCLUDES   = Include path for the header files of APR
#  APR_LIBRARIES  = Link these to use APR
#  APR_LFLAGS     = Linker flags (optional)

if (NOT APR_FOUND)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (APR_INCLUDES apr.h apr_lib.h apr_md5.h
    PATHS /usr /usr/local /sw ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES include include/apache2 include/apr-1
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (APR_LIBRARIES apr apr-1
    PATHS /usr /usr/local /sw ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES lib
    )

  if (APR_LIBRARIES)
    get_filename_component (APR_LIBRARY_DIR ${APR_LIBRARIES} PATH)
  endif (APR_LIBRARIES)
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (APR_INCLUDES AND APR_LIBRARIES)
    set (APR_FOUND TRUE)
  else (APR_INCLUDES AND APR_LIBRARIES)
    set (APR_FOUND FALSE)
    if (NOT APR_FIND_QUIETLY)
      if (NOT APR_INCLUDES)
	message (STATUS "Unable to find APR header files!")
      endif (NOT APR_INCLUDES)
      if (NOT APR_LIBRARIES)
	message (STATUS "Unable to find APR library files!")
      endif (NOT APR_LIBRARIES)
    endif (NOT APR_FIND_QUIETLY)
  endif (APR_INCLUDES AND APR_LIBRARIES)
  
  if (APR_FOUND)
    if (NOT APR_FIND_QUIETLY)
      message (STATUS "Found components for APR")
      message (STATUS "APR_INCLUDES  = ${APR_INCLUDES}")
      message (STATUS "APR_LIBRARIES = ${APR_LIBRARIES}")
    endif (NOT APR_FIND_QUIETLY)
  else (APR_FOUND)
    if (APR_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find APR!")
    endif (APR_FIND_REQUIRED)
  endif (APR_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    APR_INCLUDES
    APR_LIBRARIES
    APR_LIBRARY_DIR
    )
  
endif (NOT APR_FOUND)
