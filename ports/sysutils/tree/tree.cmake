
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Tree)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================


## ==============================================================================
##
##  Build instructions
##
## ==============================================================================

set (Tree_VERSION 1.5.3)

## Location of header files
include_directories (
  ${PROJECT_SOURCE_DIR}
  )

## Compiler flags
if (UNIX)
  if (APPLE)
    add_definitions (
      -O2
      -Wall
      -fomit-frame-pointer
      -no-cpp-precomp
      )
  else (APPLE)
    ## Linux defaults
    add_definitions (
      -ggdb
      -Wall
      -DLINUX
      -D_LARGEFILE64_SOURCE
      -D_FILE_OFFSET_BITS=64
      )
  endif (APPLE)
endif (UNIX)

file (GLOB tree_sources *.c)

add_executable (tree ${tree_sources})


## ==============================================================================
##
##  Installation
##
## ==============================================================================

install (
  TARGETS tree
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  )

# Uncomment options below for your particular OS:

# Uncomment for FreeBSD:
#CFLAGS=-O2 -Wall -fomit-frame-pointer
#LDFLAGS=-s
#XOBJS=strverscmp.o

# Uncomment for Solaris:
#CC=cc
#CFLAGS=-xO0 -v
#LDFLAGS=
#XOBJS=strverscmp.o
#MANDIR=${prefix}/share/man/man1

# Uncomment for Cygwin:
#CFLAGS=-O2 -Wall -fomit-frame-pointer -DCYGWIN
#LDFLAGS=-s
#TREE_DEST=tree.exe
#XOBJS=strverscmp.o

# Uncomment for HP/UX:
#CC=cc
#CFLAGS=-Ae +O2 +DAportable -Wall
#LDFLAGS=
#XOBJS=strverscmp.o

# Uncomment for OS/2:
#CFLAGS=-02 -Wall -fomit-frame-pointer -Zomf -Zsmall-conv
#LDFLAGS=-s -Zomf -Zsmall-conv
#XOBJS=strverscmp.o

# Uncomment for HP NonStop:
#prefix = /opt
#CC=c89
#CFLAGS=-Wextensions -WIEEE_float -g -Wnowarn=1506 -D_XOPEN_SOURCE_EXTENDED=1 \
#	 -Wallow_cplusplus_comments
#LDFLAGS=
