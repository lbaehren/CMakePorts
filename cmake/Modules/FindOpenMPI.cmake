# +-----------------------------------------------------------------------------+
# |   Copyright (C) 2011                                                        |
# |   Lars B"ahren (lbaehren@gmail.com)                                         |
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

# - Check for the presence of OPENMPI
#
# The following variables are set when OPENMPI is found:
#  OPENMPI_FOUND      = Set to true, if all components of OPENMPI
#                         have been found.
#  OPENMPI_INCLUDES   = Include path for the header files of OPENMPI
#  OPENMPI_LIBRARIES  = Link these to use OPENMPI
#  OPENMPI_LFLAGS     = Linker flags (optional)

if (NOT OPENMPI_FOUND)
    
  if (NOT OPENMPI_ROOT_DIR)
    set (OPENMPI_ROOT_DIR ${CMAKE_INSTALL_PREFIX})
  endif (NOT OPENMPI_ROOT_DIR)
  
  ##_____________________________________________________________________________
  ## Check for the header files
  
  find_path (OPENMPI_INCLUDES openmpi/ompi/mpi/cxx/comm.h ompi/mpi/cxx/info.h
    HINTS ${OPENMPI_ROOT_DIR}
    PATHS /sw /usr /usr/local /opt/local
    PATH_SUFFIXES include
    )
  
  ##_____________________________________________________________________________
  ## Check for the library
  
  ## Temporarily remove standard library prefix

  set (TMP_FIND_LIBRARY_PREFIXES ${CMAKE_FIND_LIBRARY_PREFIXES})
  
  set (CMAKE_FIND_LIBRARY_PREFIXES "" CACHE STRING
    "Library prefixes"
    FORCE
    )

  ## Go through the list of individual libraries
  
  foreach (_lib
      libompi_dbg_msgq
      mca_allocator_basic
      mca_allocator_bucket
      mca_bml_r2
      mca_btl_self
      mca_btl_sm
      mca_btl_tcp
      mca_carto_auto_detect
      mca_carto_file
      mca_coll_basic
      mca_coll_hierarch
      mca_coll_inter
      mca_coll_self
      mca_coll_sm
      mca_coll_sync
      mca_coll_tuned
      mca_crs_none
      mca_dpm_orte
      mca_errmgr_default
      mca_ess_env
      mca_ess_hnp
      mca_ess_singleton
      mca_ess_slurm
      mca_ess_tool
      mca_filem_rsh
      mca_grpcomm_bad
      mca_grpcomm_basic
      mca_io_romio
      mca_iof_hnp
      mca_iof_orted
      mca_iof_tool
      mca_maffinity_first_use
      mca_mpool_fake
      mca_mpool_rdma
      mca_mpool_sm
      mca_notifier_syslog
      mca_odls_default
      mca_oob_tcp
      mca_osc_pt2pt
      mca_osc_rdma
      mca_paffinity_darwin
      mca_paffinity_test
      mca_plm_rsh
      mca_plm_slurm
      mca_pml_cm
      mca_pml_csum
      mca_pml_ob1
      mca_pml_v
      mca_pubsub_orte
      mca_ras_slurm
      mca_rcache_vma
      mca_rmaps_load_balance
      mca_rmaps_rank_file
      mca_rmaps_round_robin
      mca_rmaps_seq
      mca_rml_oob
      mca_routed_binomial
      mca_routed_direct
      mca_routed_linear
      mca_topo_unity
      mca_vprotocol_pessimist
      )
    
    ## Convert library name to CMake variable
    string (TOUPPER ${_lib} _openmpi_var)

    ## Search for the library file
    find_library (OPENMPI_${_openmpi_var}_LIBRARY
      NAMES ${_lib}
      HINTS ${OPENMPI_ROOT_DIR}
      PATHS /sw /usr /usr/local /opt/local
      PATH_SUFFIXES lib lib/openmpi
      )

    if (OPENMPI_${_openmpi_var}_LIBRARY)
      list (APPEND OPENMPI_LIBRARIES ${OPENMPI_${_openmpi_var}_LIBRARY})
    endif (OPENMPI_${_openmpi_var}_LIBRARY)
    
  endforeach (_lib)
  
  ## Reinstate the original value of CMAKE_FIND_LIBRARY_PREFIXES
  
  set (CMAKE_FIND_LIBRARY_PREFIXES ${TMP_FIND_LIBRARY_PREFIXES} CACHE STRING
    "Library prefixes"
    FORCE
    )
  
  ##_____________________________________________________________________________
  ## Actions taken when all components have been found
  
  if (OPENMPI_INCLUDES AND OPENMPI_LIBRARIES)
    set (OPENMPI_FOUND TRUE)
  else (OPENMPI_INCLUDES AND OPENMPI_LIBRARIES)
    set (OPENMPI_FOUND FALSE)
    if (NOT OPENMPI_FIND_QUIETLY)
      if (NOT OPENMPI_INCLUDES)
	message (STATUS "Unable to find OPENMPI header files!")
      endif (NOT OPENMPI_INCLUDES)
      if (NOT OPENMPI_LIBRARIES)
	message (STATUS "Unable to find OPENMPI library files!")
      endif (NOT OPENMPI_LIBRARIES)
    endif (NOT OPENMPI_FIND_QUIETLY)
  endif (OPENMPI_INCLUDES AND OPENMPI_LIBRARIES)
  
  if (OPENMPI_FOUND)
    if (NOT OPENMPI_FIND_QUIETLY)
      message (STATUS "Found components for OPENMPI")
      message (STATUS "OPENMPI_ROOT_DIR  = ${OPENMPI_ROOT_DIR}")
      message (STATUS "OPENMPI_INCLUDES  = ${OPENMPI_INCLUDES}")
      message (STATUS "OPENMPI_LIBRARIES = ${OPENMPI_LIBRARIES}")
    endif (NOT OPENMPI_FIND_QUIETLY)
  else (OPENMPI_FOUND)
    if (OPENMPI_FIND_REQUIRED)
      message (FATAL_ERROR "Could not find OPENMPI!")
    endif (OPENMPI_FIND_REQUIRED)
  endif (OPENMPI_FOUND)
  
  ##_____________________________________________________________________________
  ## Mark advanced variables
  
  mark_as_advanced (
    OPENMPI_INCLUDES
    OPENMPI_LIBRARIES
    )
  
endif (NOT OPENMPI_FOUND)
