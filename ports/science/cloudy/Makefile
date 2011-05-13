# Makefile for compiling Cloudy on a UNIX platform
# This works only with GNU make!
# you need g++ or pathCC to create Makefile.dep (set with CXXDEPEND)
# but after that you can use any compiler you want (set with CXX)

OPT = -O3 -ftrapping-math -fno-math-errno
CXX = g++
CXXFLAGS = -ansi ${OPT} -Wall -g
LDFLAGS = ${OPT} -Wall -g
LDLIBS=
SRCDIR=.

main := maincl.cpp
source := ${notdir ${wildcard ${SRCDIR}/*.cpp}}
libsource := ${filter-out ${main},${source}}
includes := ${notdir ${wildcard ${SRCDIR}/*.h}}
objects := ${source:.cpp=.o}
libobjects := ${libsource:.cpp=.o}

# include a configuration file if one exists (or carry on without
# worrying if it doesn't)
-include Makefile.conf

ifneq (${SRCDIR},.)
  vpath %.cpp ${SRCDIR}
  vpath %.h   ${SRCDIR}
endif

# this is the compiler used to create Makefile.dep
CXXDEPEND = g++

.PHONY: clean distclean depend

# DEP_GOALS will be an empty string for targets that don't need Makefile.dep
NODEP_GOALS = clean distclean depend
DEP_GOALS = ${filter-out ${NODEP_GOALS},${MAKECMDGOALS}}

# the default target does need Makefile.dep
ifeq (${MAKECMDGOALS},)
  DEP_GOALS = need_dependencies
endif

# this is a filter to erase optimization flags from CXXFLAGS
OPTFILTER = -O -O1 -O2 -O3 -O4 -O5 -Os -xO -xO1 -xO2 -xO3 -xO4 -xO5 -fast -xvector%

CXXFLAGSNOOPT = ${filter-out ${OPTFILTER},${CXXFLAGS}}

CXXDEFINES = ${filter -D%,${CXXFLAGS}}

# Precompiling the cddefines.h header speeds up compilation dramatically with g++
# versions from 3.4.0 onwards -- unfortunately, only one header can be precompiled.
# See http://gcc.gnu.org/onlinedocs/gcc-4.2.1/gcc/Precompiled-Headers.html

presource := cddefines.h
substname := cddefines.h
preobjects :=
PWD = ${shell pwd}
ifeq ($(CXX),g++)
# check if precompiling is supported
  PRECOMPILE = ${shell ${SRCDIR}/precompile.pl}
  ifeq ($(PRECOMPILE),precompile)
   substname := cddefines.h.gch
   preobjects := ${presource:.h=.h.gch}
  endif
endif

RANLIB = ${shell which ranlib}
ifneq ($(RANLIB),)
  RANLIB = ranlib
else
  RANLIB = ar ts
endif

CDP = ${CLOUDY_DATA_PATH}
ifeq ($(CDP),)
# create reasonable default when CLOUDY_DATA_PATH not set...
  CDP = $(PWD)/${SRCDIR}/../data/
endif
ifneq (${CLOUDY_LAPACK_PATH},)
	CXXFLAGS += -DLAPACK -I${CLOUDY_LAPACK_PATH}/include
	LDLIBS += -L${CLOUDY_LAPACK_PATH}/lib -llapack
endif

cloudy.exe : ${preobjects} maincl.o libcloudy.a
	${CXX} ${LDFLAGS} -o cloudy.exe maincl.o -L. -lcloudy ${LDLIBS}

libcloudy.a: ${libobjects}
	ar ru libcloudy.a ${libobjects}
	${RANLIB} libcloudy.a

clean :
	rm -f *.o
	rm -f *.h.gch
	rm -rf SunWS_cache
	rm -f libcloudy.a
	rm -f cloudy.exe

distclean :
	rm -f *.o
	rm -f *.h.gch
	rm -rf SunWS_cache
	rm -f libcloudy.a
	rm -f cloudy.exe
	rm -f Makefile.dep
	rm -f ${SRCDIR}/Makefile.conf

# ${source} ${includes}
depend Makefile.dep:
	@echo "Updating dependency file, this may take a little while"
	@cd ${SRCDIR}; \
	${CXXDEPEND} -MM -DMM ${CXXDEFINES} ${source} | sed "s/${presource}/${substname}/" > $(PWD)/Makefile.dep; \
	${CXXDEPEND} -MM -DMM ${CXXDEFINES} ${presource} | sed 's/\.o:/.h.gch:/' >> $(PWD)/Makefile.dep;

cpu.o:
	${CXX} ${CXXFLAGS} -c -DCLOUDY_DATA_PATH=\"${CDP}\" $<

# an explicit -O0 is needed for some compilers like icc
parse_crashdo.o:
	${CXX} ${CXXFLAGSNOOPT} -O0 -c $<

%.h.gch: %.h
	${CXX} ${CXXFLAGS} -o $@ $<

# only include Makefile.dep when we really need it, this prevents unnecessary builds of Makefile.dep
ifneq (${DEP_GOALS},)
-include Makefile.dep
endif
