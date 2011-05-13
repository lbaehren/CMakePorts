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

# - Check for the presence of LIBINCONV
#
# The following variables are set when LIBINCONV is found:
#  LIBINCONV_FOUND       = Set to true, if all components of LIBINCONV have been
#                          found.
#  LIBINCONV_INCLUDES    = Include path for the header files of LIBINCONV
#  LIBINCONV_LIBRARIES   = Link these to use LIBINCONV
#  LIBINCONV_LFLAGS      = Linker flags (optional)

if (NOT LIBINCONV_FOUND)
    
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (LIBINCONV_INCLUDES iconv.h
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  find_library (LIBINCONV_LIBRARIES libiconv
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES lib
    )
  
  ##_____________________________________________________________________________
  ## Check for the iconv executable
  
  find_library (ICONV_EXECUTABLE iconv
    PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES bin
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (LIBINCONV_INCLUDES AND LIBINCONV_LIBRARIES)
    set (LIBINCONV_FOUND TRUE)
  else (LIBINCONV_INCLUDES AND LIBINCONV_LIBRARIES)
    set (LIBINCONV_FOUND FALSE)
    if (NOT LIBINCONV_FIND_QUIETLY)
      if (NOT LIBINCONV_INCLUDES)
	message (STATUS "Unable to find LIBINCONV header files!")
      endif (NOT LIBINCONV_INCLUDES)
      if (NOT LIBINCONV_LIBRARIES)
	message (STATUS "Unable to find LIBINCONV library files!")
      endif (NOT LIBINCONV_LIBRARIES)
    endif (NOT LIBINCONV_FIND_QUIETLY)
  endif (LIBINCONV_INCLUDES AND LIBINCONV_LIBRARIES)

  if (LIBINCONV_FOUND)
    if (NOT LIBINCONV_FIND_QUIETLY)
      message (STATUS "Found components for LIBINCONV")
      message (STATUS "LIBINCONV_INCLUDES  = ${LIBINCONV_INCLUDES}")
      message (STATUS "LIBINCONV_LIBRARIES = ${LIBINCONV_LIBRARIES}")
      message (STATUS "ICONV_EXECUTABLE    = ${ICONV_EXECUTABLE}")
    endif (NOT LIBINCONV_FIND_QUIETLY)
  else (LIBINCONV_FOUND)
    if (LIBINCONV_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find LIBINCONV!")
    endif (LIBINCONV_FIND_REQUIRED)
  endif (LIBINCONV_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    LIBINCONV_INCLUDES
    LIBINCONV_LIBRARIES
    ICONV_EXECUTABLE
    )
  
endif (NOT LIBINCONV_FOUND)
