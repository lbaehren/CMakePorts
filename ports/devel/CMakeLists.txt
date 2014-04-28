
add_custom_target (devel ALL)

foreach (_package
    bison
    doxygen
    )

    add_custom_target (${_package} ALL
        COMMAND sudo port install ${_package}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Installing port ${_package} ..."
    )

    add_dependencies (devel ${_package})

endforeach (_package)


add_subdirectory (apr)
add_subdirectory (apr-util)
add_subdirectory (autoconf)
add_subdirectory (autogen)
add_subdirectory (automake)
add_subdirectory (boost)
add_subdirectory (cloog-ppl)
add_subdirectory (cmake)
add_subdirectory (cppunit)
add_subdirectory (gettext)
add_subdirectory (git)
add_subdirectory (gmp)
add_subdirectory (libmpc)
add_subdirectory (libtool)
add_subdirectory (log4cplus)
add_subdirectory (mpfr)
add_subdirectory (ncurses)
add_subdirectory (openssl)
add_subdirectory (ppl)
add_subdirectory (polylib)
add_subdirectory (popt)
add_subdirectory (pth)
add_subdirectory (qt)
add_subdirectory (readline)
add_subdirectory (subversion)
add_subdirectory (treecc)
add_subdirectory (valgrind)
