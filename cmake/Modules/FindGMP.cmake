# +-----------------------------------------------------------------------------+
# |   Copyright (C) 2007                                                        |
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

# - Check for the presence of GMP
#
# The following variables are set when GMP is found:
#  GMP_FOUND       = Set to true, if all components of GMP
#                          have been found.
#  GMP_INCLUDES   = Include path for the header files of GMP
#  GMP_LIBRARIES  = Link these to use GMP
#  GMP_LFLAGS     = Linker flags (optional)

if (NOT GMP_FOUND)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (GMP_INCLUDES gmp.h)
  
  ##_____________________________________________________________________________
  ## Check for the library

  set (GMP_LIBRARIES "")

  find_library (GMP_GMP_LIBRARY gmp)
  if (GMP_GMP_LIBRARY)
    list (APPEND GMP_LIBRARIES ${GMP_GMP_LIBRARY})
  endif (GMP_GMP_LIBRARY)
  
  find_library (GMP_GMPXX_LIBRARY gmpxx)
  if (GMP_GMPXX_LIBRARY)
    list (APPEND GMP_LIBRARIES ${GMP_GMPXX_LIBRARY})
  endif (GMP_GMPXX_LIBRARY)  
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (GMP_INCLUDES AND GMP_LIBRARIES)
    set (GMP_FOUND TRUE)
  else (GMP_INCLUDES AND GMP_LIBRARIES)
    set (GMP_FOUND FALSE)
    if (NOT GMP_FIND_QUIETLY)
      if (NOT GMP_INCLUDES)
	message (STATUS "Unable to find GMP header files!")
      endif (NOT GMP_INCLUDES)
      if (NOT GMP_LIBRARIES)
	message (STATUS "Unable to find GMP library files!")
      endif (NOT GMP_LIBRARIES)
    endif (NOT GMP_FIND_QUIETLY)
  endif (GMP_INCLUDES AND GMP_LIBRARIES)
  
  if (GMP_FOUND)
    if (NOT GMP_FIND_QUIETLY)
      message (STATUS "Found components for GMP")
      message (STATUS "GMP_INCLUDES  = ${GMP_INCLUDES}")
      message (STATUS "GMP_LIBRARIES = ${GMP_LIBRARIES}")
    endif (NOT GMP_FIND_QUIETLY)
  else (GMP_FOUND)
    if (GMP_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find GMP!")
    endif (GMP_FIND_REQUIRED)
  endif (GMP_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    GMP_INCLUDES
    GMP_LIBRARIES
    GMP_GMP_LIBRARY
    GMP_GMPXX_LIBRARY
    )
  
endif (NOT GMP_FOUND)
