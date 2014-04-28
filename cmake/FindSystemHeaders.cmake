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

# - Check for the presence of system header files

##_______________________________________________________________________________
## Check for system header files

find_path (HAVE_LIBGEN_H libgen.h
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include
  )

find_path (HAVE_STDINT_H stdint.h
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include
  )

find_path (HAVE_STDLIB_H stdlib.h
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include
  )

find_path (HAVE_STRING_H string.h
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include
  )

find_path (HAVE_STRINGS_H strings.h
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include
  )

##_____________________________________________________________________________
## Check for system header files (sys)

find_path (HAVE_SYS_STAT_H sys/stat.h
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include
  )

find_path (HAVE_SYS_TIME_H sys/time.h
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include
  )

find_path (HAVE_SYS_TYPES_H sys/types.h
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include
  )

find_path (HAVE_SYS_UTIME_H sys/utime.h
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include
  )
