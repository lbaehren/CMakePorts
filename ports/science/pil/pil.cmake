
## Name of the project handled by CMake
project (PIL)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

##__________________________________________________________
## Build the library

include_directories (${PIL_SOURCE_DIR})

add_library (pil pil.c pil_sys.c pil_error.c)

## installation of the library
install (TARGETS pil
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  )
## installation of the header files
install (FILES pil.h pil_error.h
  DESTINATION include/pil
  )

##__________________________________________________________
## Build the executables

foreach (src pget plist pquery2 pset punlearn)
  ## compiler instructions
  add_executable (${src} ${src}.c)
  ## linker instructions
  target_link_libraries (${src} pil)
  ## installation instructions
  install (TARGETS ${src}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    )
endforeach (src)

##__________________________________________________________
## Build the test programs

include (CTest)
enable_testing()

foreach (src pilcdemo pil_test pil_gen_c_code)
  ## compiler instructions
  add_executable (${src} ${src}.c)
  ## linker instructions
  target_link_libraries (${src} pil)
  ## installation instructions
  install (TARGETS ${src}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    )
endforeach (src)

add_test (pilcdemo pilcdemo)
add_test (pil_test pil_test)