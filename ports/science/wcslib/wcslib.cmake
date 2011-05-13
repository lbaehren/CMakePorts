
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (WCSLIB)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ___ CMake modules _____________________________

include (CheckIncludeFile)
include (CheckFunctionExists)
include (CheckLibraryExists)
include (CheckSymbolExists)
include (CheckTypeSize)
include (TestBigEndian)

## ==============================================================================
##
##  System inspection
##
## ==============================================================================

include (FindFLEX)

## ___ Check include files _______________________

check_include_file (errno.h      HAVE_ERRNO_H     )
check_include_file (inttypes.h   HAVE_INTTYPES_H  )
check_include_file (unistd.h     HAVE_UNISTD_H    )

## ___ Check type sizes __________________________

check_type_size ("int *"          SIZEOF_INT_P     )
check_type_size ("size_t"         SIZEOF_SIZE_T    )

## ___ Check function definitions ________________

check_function_exists (floor    HAVE_FLOOR   )
check_function_exists (malloc   HAVE_MALLOC  )
check_function_exists (memset   HAVE_MEMSET  )
check_function_exists (pow      HAVE_POW     )
check_function_exists (sqrt     HAVE_SQRT    )
check_function_exists (strchr   HAVE_STRCHR  )
check_function_exists (strstr   HAVE_STRSTR  )

## ___ Check for CFITSIO library _________________

find_path (CFITSIO_INCLUDES fitsio.h
  PATHS /sw /usr /usr/local /opt/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES include include/cfitsio
  )

find_library (CFITSIO_LIBRARY cfitsio
  PATHS /sw /usr /usr/local ${CMAKE_INSTALL_PREFIX}
  PATH_SUFFIXES lib
  )

## ==============================================================================
##
##  C library (libwcs)
##
## ==============================================================================

##_______________________________________________________________________________
## Include directories

include_directories (
  ${PROJECT_SOURCE_DIR}
  ${PROJECT_SOURCE_DIR}/C
  ${PROJECT_BINARY_DIR}
  ${PROJECT_BINARY_DIR}/C
  ${CFITSIO_INCLUDES}
)

##_______________________________________________________________________________
## Create configured header file (wcsconfig.h)

configure_file (
  ${PROJECT_SOURCE_DIR}/wcsconfig.h.in
  ${PROJECT_BINARY_DIR}/wcsconfig.h
  )

##_______________________________________________________________________________
## Process Flex input files

if (FLEX_EXECUTABLE)
  
  file (GLOB flex_inputs C/*.l)
  
  if (flex_inputs)
    foreach (_infile ${flex_inputs})
      ## extract filename components
      get_filename_component (_name ${_infile} NAME_WE)
      ## run the input file through flex
      execute_process (
	WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/C
	COMMAND ${FLEX_EXECUTABLE} -o${PROJECT_SOURCE_DIR}/C/${_name}.c -P${_name} ${_name}.l
	TIMEOUT 30
	ERROR_VARIABLE flex_error
	OUTPUT_QUIET
	)
    endforeach (_infile)
  else (flex_inputs)
  endif (flex_inputs)
  
else (FLEX_EXECUTABLE)

  message (SEND_ERROR "[WCSLIB] Missing Flex lexical parser - unable to continue!")

endif (FLEX_EXECUTABLE)

##_______________________________________________________________________________
## Create the library

file (GLOB wcslib_sources C/*.c)
file (GLOB wcslib_headers C/*.h)

if (wcslib_sources)
  ## additional compiler flags
  add_definitions (-fPIC)
  ## compiler instructions
  add_library (wcs ${wcslib_sources})
  ## linker instructions
  target_link_libraries (wcs ${CFITSIO_LIBRARY})
  ## installation instructions
  install (
    TARGETS wcs
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    )
else (wcslib_sources)
  message (SEND_ERROR "[WCSLIB] No source file for library - unable to continue!")
endif (wcslib_sources)

if (wcslib_headers)
  install (FILES ${wcslib_headers} ${PROJECT_BINARY_DIR}/wcsconfig.h
    DESTINATION include/wcslib
    )
endif (wcslib_headers)
