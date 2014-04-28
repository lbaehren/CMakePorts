#-------------------------------------------------------------------------------
# Copyright (c) 2011-2014, Lars Baehren <lbaehren@gmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#-------------------------------------------------------------------------------

## =============================================================================
##
##  Macports
##
## =============================================================================

##______________________________________________________________________________
## Variables

PORT_COMMAND = sudo /opt/local/bin/port install

macports_version=2.2.1
macports_archive=MacPorts-${macports_version}.tar.gz
macports_url=https://distfiles.macports.org/MacPorts/${macports_archive}

version_clang=35

##______________________________________________________________________________
## Default target

default: update

##______________________________________________________________________________
## Update existing MacPorts installation

update:
	@echo "-- Updating port definitions ..."
	sudo port -v selfupdate
	@echo "-- Upgrade outdated ports ..."
	sudo port upgrade outdated

##______________________________________________________________________________
## Install MacPorts from source

install_macports:
	@echo "-- Downloading Macports installation package ..."
	curl ${macports_url} -o ${macports_archive} -k
	@echo "-- Unpack source archive ..."
	tar -xvzf ${macports_archive}
	@echo "-- Configure MacPorts ..."
	cd MacPorts-${macports_version} && ./configure --with-tcl=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk/System/Library/Frameworks/Tcl.framework/ --with-tclinclude=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers
	@echo "-- Build and install MacPorts ..."
	cd MacPorts-${macports_version} && make && sudo make install
	@echo "--Post-installation clean-up ..."
	rm -rf MacPorts-${macports_version}*
	@echo "-- Update port definitions to install base packages ..."
	sudo port -v selfupdate
	make install_base

##______________________________________________________________________________
## Remove all components of MacPorts from the system; this not only includes
## deactivation of all installed ports, but also removal of configuration files
## installed outside /opt/local.

uninstall_macports:
	@echo "-- Uninstall all the installed ports ..."
	sudo port -fp uninstall --follow-dependents installed

	@echo "-- Clean up directories used by MacPorts ..."
	sudo rm -rf /opt/local
	sudo rm -rf /Applications/DarwinPorts
	sudo rm -rf /Applications/MacPorts
	sudo rm -rf /Library/LaunchDaemons/org.macports.*
	sudo rm -rf /Library/Receipts/DarwinPorts*.pkg
	sudo rm -rf /Library/Receipts/MacPorts*.pkg
	sudo rm -rf /Library/StartupItems/DarwinPortsStartup
	sudo rm -rf /Library/Tcl/darwinports1.0
	sudo rm -rf /Library/Tcl/macports1.0
	sudo rm -rf ~/.macports

## =============================================================================
##
##  Ports
##
## =============================================================================


install_base: office devel science multimedia

##______________________________________________________________________________
##                                                                     Archivers



##______________________________________________________________________________
##                                                                     Databases

databases:
	${PORT_COMMAND} sqlite3


##______________________________________________________________________________
##                                                          Development packages

devel: lang python
	${PORT_COMMAND} apr
	${PORT_COMMAND} apr-util
	${PORT_COMMAND} autoconf
	${PORT_COMMAND} automake
	${PORT_COMMAND} bison
	${PORT_COMMAND} blitz
	${PORT_COMMAND} boost +python27
	${PORT_COMMAND} cctools +llvm${version_clang}
	${PORT_COMMAND} cmake
	${PORT_COMMAND} cppunit
	${PORT_COMMAND} doxygen
	${PORT_COMMAND} expat
	${PORT_COMMAND} flex
	${PORT_COMMAND} geany
	${PORT_COMMAND} git-core +credential_osxkeychain+doc+pcre+perl5_12+python27+svn
	${PORT_COMMAND} libconfig-hr
	${PORT_COMMAND} libgphoto2
	${PORT_COMMAND} mercurial
	${PORT_COMMAND} ncurses
	${PORT_COMMAND} openssl
	${PORT_COMMAND} popt
	${PORT_COMMAND} subversion
	${PORT_COMMAND} swig
	${PORT_COMMAND} yaml-cpp

##______________________________________________________________________________
##                                                                       Editors

editors:
	${PORT_COMMAND} nano

##______________________________________________________________________________
##                                                  Graphics libraries and tools

graphics:
	${PORT_COMMAND} exiv2
	${PORT_COMMAND} freetype
	${PORT_COMMAND} ilmbase
	${PORT_COMMAND} libexif
	${PORT_COMMAND} openexr
	${PORT_COMMAND} poppler
	${PORT_COMMAND} tiff

##______________________________________________________________________________
##                                           Programming languages and compilers

lang:
	${PORT_COMMAND} clang-3.5 +analyzer+python27
	sudo port select --set python python27

##______________________________________________________________________________
##                                                                   Mathematics

math:
	${PORT_COMMAND} fftw-3
	${PORT_COMMAND} gmp
	${PORT_COMMAND} mpfr

##______________________________________________________________________________
##                                                                    Multimedia

multimedia: graphics
	${PORT_COMMAND} mplayer-devel

##______________________________________________________________________________
##                                                Networking libraries and tools

net:
	${PORT_COMMAND} wget +ssl

##______________________________________________________________________________
##                                                 Office and productivity tools

office:
	${PORT_COMMAND} task

##______________________________________________________________________________
##                                                               Python packages

python:
	${PORT_COMMAND} py27-pip
	sudo port select --set pip pip27
	sudo pip install Cython
	sudo pip install Matplotlib
	sudo pip install h5py
	sudo pip install numpy
	sudo pip install pyfits
	sudo pip install pyaml
	sudo pip install scipy
	sudo pip install uncertainties

##______________________________________________________________________________
##                                             Packages for scientific computing

science: math
	${PORT_COMMAND} cfitsio
	${PORT_COMMAND} curl +ssl
	${PORT_COMMAND} gsl-devel
	${PORT_COMMAND} hdf5-18 +cxx
	${PORT_COMMAND} netcdf +netcdf4
	${PORT_COMMAND} netcdf-cxx

##______________________________________________________________________________
##                                                              System utilities

sysutils:
	${PORT_COMMAND} file
	${PORT_COMMAND} libmagic
	${PORT_COMMAND} tree

##______________________________________________________________________________
##                                                                         LaTeX

tex:
	${PORT_COMMAND} texlive +doc+full

##______________________________________________________________________________
##                                                               Text processing

textproc: tex
	${PORT_COMMAND} docbook-xml
