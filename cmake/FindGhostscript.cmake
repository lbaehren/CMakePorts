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

# - Check for the presence of GHOSTSCRIPT
#
# The following variables are set when GHOSTSCRIPT is found:
#  GHOSTSCRIPT_FOUND      = Set to true, if all components of GHOSTSCRIPT
#                           have been found.
#  GHOSTSCRIPT_INCLUDES   = Include path for the header files of GHOSTSCRIPT
#  GHOSTSCRIPT_LIBRARIES  = Link these to use GHOSTSCRIPT
#  GHOSTSCRIPT_LFLAGS     = Linker flags (optional)

if (NOT GHOSTSCRIPT_FOUND)
    
  if (NOT GHOSTSCRIPT_ROOT_DIR)
    set (GHOSTSCRIPT_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT GHOSTSCRIPT_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the executables
  
  find_program (GHOSTSCRIPT_EXECUTABLE gs ghostscript
    HINTS ${GHOSTSCRIPT_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES bin
    )
  
  find_program (EPS2EPS_EXECUTABLE eps2eps
    HINTS ${GHOSTSCRIPT_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES bin
    )
  
  find_program (DVIPDF_EXECUTABLE dvipdf
    HINTS ${GHOSTSCRIPT_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES bin
    )
  
  find_program (PS2PS2_EXECUTABLE ps2ps2
    HINTS ${GHOSTSCRIPT_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES bin
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (GHOSTSCRIPT_EXECUTABLE)
    set (GHOSTSCRIPT_FOUND TRUE)
  else (GHOSTSCRIPT_EXECUTABLE)
    set (GHOSTSCRIPT_FOUND FALSE)
    if (NOT GHOSTSCRIPT_FIND_QUIETLY)
      message (STATUS "Unable to find Ghostscript executable gs!")
    endif (NOT GHOSTSCRIPT_FIND_QUIETLY)
  endif (GHOSTSCRIPT_EXECUTABLE)
  
  if (GHOSTSCRIPT_FOUND)
    if (NOT GHOSTSCRIPT_FIND_QUIETLY)
      message (STATUS "Found components for GHOSTSCRIPT")
      message (STATUS "GHOSTSCRIPT_ROOT_DIR   = ${GHOSTSCRIPT_ROOT_DIR}")
      message (STATUS "GHOSTSCRIPT_EXECUTABLE = ${GHOSTSCRIPT_EXECUTABLE}")
      message (STATUS "EPS2EPS_EXECUTABLE     = ${EPS2EPS_EXECUTABLE}")
      message (STATUS "DVIPDF_EXECUTABLE      = ${DVIPDF_EXECUTABLE}")
      message (STATUS "PS2PS2_EXECUTABLE      = ${PS2PS2_EXECUTABLE}")
    endif (NOT GHOSTSCRIPT_FIND_QUIETLY)
  else (GHOSTSCRIPT_FOUND)
    if (GHOSTSCRIPT_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find GHOSTSCRIPT!")
    endif (GHOSTSCRIPT_FIND_REQUIRED)
  endif (GHOSTSCRIPT_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    GHOSTSCRIPT_ROOT_DIR
    GHOSTSCRIPT_EXECUTABLE
    EPS2EPS_EXECUTABLE
    DVIPDF_EXECUTABLE
    PS2PS2_EXECUTABLE
    )
  
endif (NOT GHOSTSCRIPT_FOUND)
