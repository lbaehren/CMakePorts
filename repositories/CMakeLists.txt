
## ==============================================================================
##
##  CMake project settings
##
## ==============================================================================

## Name of the project handled by CMake
project (Repositories)

## Minimum required version of CMake to configure the project
cmake_minimum_required (VERSION 2.8)

## Enforced CMake policy 
cmake_policy (VERSION 2.8)

## ==============================================================================
##
##  Macro definitions
##
## ==============================================================================

macro (add_svn_repository _projectName _projectRepos)
  if (EXISTS ${PROJECT_SOURCE_DIR}/${_projectName})
    add_custom_target(${_projectName} ALL
      COMMAND git svn rebase
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/${_projectName}
      COMMENT "Updating clone of repository ${_projectName} ..."
      )
  else (EXISTS ${PROJECT_SOURCE_DIR}/${_projectName})
    add_custom_target(${_projectName} ALL
      COMMAND git svn clone ${_projectRepos} ${_projectName}
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Cloning repository ${_projectName} ..."
      )
  endif (EXISTS ${PROJECT_SOURCE_DIR}/${_projectName})
endmacro (add_svn_repository)

## ==============================================================================
##
##  Clones of Git repositories
##
## ==============================================================================

foreach (_repos
    git://github.com/nextgen-astrodata/DAL.git
    git://cmake.org/cmake.git
    git://git.kernel.org/pub/scm/git/git.git
    https://github.com/acaudwell/Gource.git
    https://github.com/FlowingMedia/TimeFlow.git
    https://github.com/pelican/pelican.git
    https://lbaehren@github.com/pelican/pelican-lofar.git
    https://github.com/pelican/pelican-astro.git
    https://github.com/pschella/tmf.git
    https://github.com/numpy/numpy.git
    https://github.com/scipy/scipy.git
    )

  ## Extract project name
  get_filename_component (_projectName ${_repos} NAME_WE)

  ## Check if we already have a clone of the repository
  
  if (EXISTS ${PROJECT_SOURCE_DIR}/${_projectName})
    
    ## ... if yes, update the local version
    add_custom_target(${_projectName} ALL
      COMMAND git fetch
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/${_projectName}
      COMMENT "Updating clone of repository ${_projectName} ..."
      )
    
  else (EXISTS ${PROJECT_SOURCE_DIR}/${_projectName})
    
    ## ... if not, make a clone of the original repository
    add_custom_target(${_projectName} ALL
      COMMAND git clone --bare ${_repos} ${_projectName}
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      COMMENT "Cloning repository ${_projectName} ..."
      )
    
  endif (EXISTS ${PROJECT_SOURCE_DIR}/${_projectName})
  
endforeach (_repos)

## ==============================================================================
##
##  Clones of SVN repositories
##
## ==============================================================================

add_svn_repository (usg_documents http://usg.lofar.org/svn/documents/trunk    )
add_svn_repository (usg_code      http://usg.lofar.org/svn/code/trunk         )
add_svn_repository (tkp_code      http://svn.transientskp.org/code            )
add_svn_repository (tkp_docs      http://svn.transientskp.org/docs            )
add_svn_repository (casacore      http://casacore.googlecode.com/svn/trunk    )
add_svn_repository (Fluke         http://flukeformac.googlecode.com/svn/trunk )
add_svn_repository (root          http://root.cern.ch/svn/root/trunk          )
