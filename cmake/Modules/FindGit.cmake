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

# - Check for the presence of GIT
#
# The following variables are set when GIT is found:
#  GIT_FOUND       = Set to true, if all components of GIT have been found.
#  GIT_EXECUTABLE  = Path to the Git executable
#  GIT_VERSION     = Full version string

if (NOT FIND_GIT_CMAKE)
  
  set (FIND_GIT_CMAKE TRUE)

  ## Find executable
  
  find_program (GIT_EXECUTABLE git
    PATHS /sw /usr /opt /opt/usr ${CMAKE_INSTALL_PREFIX}
    PATH_SUFFIXES bin local/bin
    )

  ## Extract version information

  if (GIT_EXECUTABLE)
    ## run `git --version` to get version number
    execute_process(
      COMMAND ${GIT_EXECUTABLE} --version
      OUTPUT_VARIABLE _version
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_STRIP_TRAILING_WHITESPACE
      )

    if (_version)
      string (REGEX REPLACE "git version" "" _version ${_version})
      string (REGEX REPLACE " " "" _version ${_version})
    endif (_version)

  endif (GIT_EXECUTABLE)

  ## Determine major, minor and patch version

  if (_version)

    ## Set the full version
    
    set (GIT_VERSION ${_version})

    ## Extract major version

    string (REGEX MATCH "[0-9]" GIT_VERSION_MAJOR ${_version})

    ## Extract minor version

    string (REGEX REPLACE "${GIT_VERSION_MAJOR}." "" _version ${_version} )
    string (REGEX MATCH "[0-9]" GIT_VERSION_MINOR ${_version})

    ## Extract patch version

    string (REGEX REPLACE "${GIT_VERSION_MINOR}." "" _version ${_version} )
    string (REGEX MATCH "[0-9]" GIT_VERSION_PATCH ${_version})

  endif (_version)
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (GIT_EXECUTABLE)
    set (GIT_FOUND TRUE)
  else (GIT_EXECUTABLE)
    set (GIT_FOUND FALSE)
    if (NOT GIT_FIND_QUIETLY)
	message (STATUS "Unable to find Git executable!")
    endif (NOT GIT_FIND_QUIETLY)
  endif (GIT_EXECUTABLE)
  
  if (GIT_FOUND)
    if (NOT GIT_FIND_QUIETLY)
      message (STATUS "Found components for GIT")
      message (STATUS "GIT_EXECUTABLE    = ${GIT_EXECUTABLE}")
      message (STATUS "GIT_VERSION       = ${GIT_VERSION}")
      message (STATUS "GIT_VERSION_MAJOR = ${GIT_VERSION_MAJOR}")
      message (STATUS "GIT_VERSION_MINOR = ${GIT_VERSION_MINOR}")
      message (STATUS "GIT_VERSION_PATCH = ${GIT_VERSION_PATCH}")
    endif (NOT GIT_FIND_QUIETLY)
  else (GIT_FOUND)
    if (GIT_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find GIT!")
    endif (GIT_FIND_REQUIRED)
  endif (GIT_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    GIT_EXECUTABLE
    GIT_VERSION
    GIT_VERSION_MAJOR
    GIT_VERSION_MINOR
    GIT_VERSION_PATCH
    )
  
endif (NOT FIND_GIT_CMAKE)
