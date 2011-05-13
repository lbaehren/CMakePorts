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

# - Check for the presence of AUTOCONF
#
# The following variables are set when AUTOCONF is found:
#  AUTOCONF_FOUND       = Set to true, if all components of AUTOCONF
#                          have been found.
#  AUTOCONF_INCLUDES   = Include path for the header files of AUTOCONF
#  AUTOCONF_LIBRARIES  = Link these to use AUTOCONF
#  AUTOCONF_LFLAGS     = Linker flags (optional)

if (NOT FIND_AUTOCONF_CMAKE)
  
  set (FIND_AUTOCONF_CMAKE TRUE)
  
  foreach (_program
      autoupdate
      autoscan
      autoreconf
      autom4te
      autoheader
      autoconf
      )

    string (TOUPPER ${_program} _var)

    find_program (${_var}_EXECUTABLE ${_program}
      PATHS /sw /usr /opt /opt/usr ${CMAKE_INSTALL_PREFIX}
      PATH_SUFFIXES bin local/bin
      )
    
  endforeach (_program)
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (AUTOCONF_EXECUTABLE)
    set (AUTOCONF_FOUND TRUE)
  else (AUTOCONF_EXECUTABLE)
    set (AUTOCONF_FOUND FALSE)
    if (NOT AUTOCONF_FIND_QUIETLY)
      message (STATUS "Unable to find AUTOCONF executable!")
    endif (NOT AUTOCONF_FIND_QUIETLY)
  endif (AUTOCONF_EXECUTABLE)
  
  if (AUTOCONF_FOUND)
    if (NOT AUTOCONF_FIND_QUIETLY)
      message (STATUS "Found components for AUTOCONF")
      message (STATUS "autoconf executable   = ${AUTOCONF_EXECUTABLE}")
      message (STATUS "autoheader executable = ${AUTOHEADER_EXECUTABLE}")
    endif (NOT AUTOCONF_FIND_QUIETLY)
  else (AUTOCONF_FOUND)
    if (AUTOCONF_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find AUTOCONF!")
    endif (AUTOCONF_FIND_REQUIRED)
  endif (AUTOCONF_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    AUTOCONF_EXECUTABLE
    )
  
endif (NOT FIND_AUTOCONF_CMAKE)
