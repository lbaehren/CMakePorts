
## 1. Introduction

CMakePorts is a small custom project to provide a simple framework for the
installation of – predominantly – scientific software packages across several
platforms; it uses CMake as tool to handle the configuration, build and
installation, as well as keeping track of package dependencies (somewhat similar
to MacPorts).

## 2. Configuration

The following configuration options are available (last column lists the
default value assigned to the variable):

    ENABLE_SUDO_INSTALL       "Use sudo when installing package?"        NO
    ENABLE_LOCAL_REPOSITORIES "Enable keeping local repository clones?"  YES
    VERBOSE_CONFIGURE         "Be verbose during configuration?"         NO
