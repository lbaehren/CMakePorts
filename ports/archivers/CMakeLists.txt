
add_custom_target (archivers ALL)

foreach (_package
    bzip2
    szip
    unrar
    xz
    zip
    zlib
    )

    add_custom_command (
        TARGET archivers
        PRE_BUILD
        COMMAND sudo port install ${_package}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Installing port ${_package} ..."
                )

endforeach (_package)

