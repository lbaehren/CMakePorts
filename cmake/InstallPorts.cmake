
#macro (add_ports _category _ports)
#endmacro (add_ports)

macro (add_port _port _category)

    if (NOT TARGET ${_category})
        add_custom_target (${_category} ALL)
    endif (NOT TARGET ${_category})

    add_custom_command (TARGET ${_category}
        PRE_LINK
        COMMAND command1 [ARGS] [args1...]
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Installing port ${_port} ..."
        )

endmacro (add_port)


