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

# - Check for the presence of LOCAL_REPOSITORIES
#
# The following variables are set when LOCAL_REPOSITORIES is found:
#  LOCAL_REPOSITORIES_FOUND = Set to true, if all components of LOCAL_REPOSITORIES
#                         have been found.

if (NOT LOCAL_REPOSITORIES_FOUND)
    
  if (NOT LOCAL_REPOSITORIES_ROOT_DIR)
    set (LOCAL_REPOSITORIES_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT LOCAL_REPOSITORIES_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (LOCAL_REPOSITORIES DAL/.git Fluke/.git git/.git xGPU/.git 
    HINTS ${LOCAL_REPOSITORIES_ROOT_DIR}
    PATHS 
    ${PROJECT_SOURCE_DIR}
    ${PROJECT_SOURCE_DIR}/..
    ${PROJECT_SOURCE_DIR}/../..
    ${PROJECT_SOURCE_DIR}/../../..
    /sw /usr /usr/local /opt/local
    ENV HOME
    PATH_SUFFIXES Repositories
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (LOCAL_REPOSITORIES)
    set (LOCAL_REPOSITORIES_FOUND TRUE)
  else (LOCAL_REPOSITORIES)
    set (LOCAL_REPOSITORIES_FOUND FALSE)
    if (NOT LOCAL_REPOSITORIES_FIND_QUIETLY)
      if (NOT LOCAL_REPOSITORIES)
	message (STATUS "Unable to find directory with local repositories!")
      endif (NOT LOCAL_REPOSITORIES)
    endif (NOT LOCAL_REPOSITORIES_FIND_QUIETLY)
  endif (LOCAL_REPOSITORIES)
  
  if (LOCAL_REPOSITORIES_FOUND)
    if (NOT LOCAL_REPOSITORIES_FIND_QUIETLY)
      message (STATUS "Found components for LOCAL_REPOSITORIES")
      message (STATUS "LOCAL_REPOSITORIES_ROOT_DIR = ${LOCAL_REPOSITORIES_ROOT_DIR}")
      message (STATUS "LOCAL_REPOSITORIES          = ${LOCAL_REPOSITORIES}")
    endif (NOT LOCAL_REPOSITORIES_FIND_QUIETLY)
  else (LOCAL_REPOSITORIES_FOUND)
    if (LOCAL_REPOSITORIES_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find LOCAL_REPOSITORIES!")
    endif (LOCAL_REPOSITORIES_FIND_REQUIRED)
  endif (LOCAL_REPOSITORIES_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    LOCAL_REPOSITORIES_ROOT_DIR
    LOCAL_REPOSITORIES
    )
  
endif (NOT LOCAL_REPOSITORIES_FOUND)
