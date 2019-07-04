SHELL := /bin/bash

PROJECT = zlog
MAJ_VERSION = 1.2
MIN_VERSION = 14

UPSTREAM_VERSION = $(MAJ_VERSION).$(MIN_VERSION)
DEBIAN_REVISION = 0
VERSION = $(UPSTREAM_VERSION)-$(DEBIAN_REVISION)

LOC_INC_DIR = zlog/src
LOC_LIB_DIR = zlog/src

LIBNAME = lib$(PROJECT)

TGT_INCLUDE = /opt/smx/include
TGT_LIB = /opt/smx/lib
TGT_CONF = /opt/smx/conf

DPKG_DIR = dpkg
DPKG_CTL_DIR = dpkg-ctl
DPKGS = $(DPKG_DIR)/$(LIBNAME)_$(VERSION)_amd64 \
	   $(DPKG_DIR)/$(LIBNAME)_amd64-dev

STATLIB = $(LOC_LIB_DIR)/$(LIBNAME).a
DYNLIB = $(LOC_LIB_DIR)/$(LIBNAME).so

INCLUDES = $(LOC_INC_DIR)/*.h

all:
	$(MAKE) -C zlog/.

.PHONY: clean install uninstall dpkg $(DPKGS) dpkg-clean

install:
	mkdir -p $(TGT_LIB) $(TGT_INCLUDE) $(TGT_CONF)
	cp -a $(INCLUDES) $(TGT_INCLUDE)/.
	cp -a $(STATLIB) $(TGT_LIB)/$(LIBNAME).a.$(MAJ_VERSION)
	cp -a $(DYNLIB) $(TGT_LIB)/$(LIBNAME).so.$(MAJ_VERSION)
	ln -sf $(LIBNAME).so.$(MAJ_VERSION) $(TGT_LIB)/$(LIBNAME).so
	ln -sf $(LIBNAME).a.$(MAJ_VERSION) $(TGT_LIB)/$(LIBNAME).a
	cp zlog.conf $(TGT_CONF)/default.zlog

uninstall:
	rm $(addprefix $(TGT_INCLUDE)/,$(notdir $(wildcard $(INCLUDES))))
	rm $(TGT_LIB)/$(LIBNAME).a.$(MAJ_VERSION)
	rm $(TGT_LIB)/$(LIBNAME).so.$(MAJ_VERSION)
	rm $(TGT_LIB)/$(LIBNAME).a
	rm $(TGT_LIB)/$(LIBNAME).so
	rm $(TGT_CONF)/default.zlog

clean:
	$(MAKE) clean -C zlog

dpkg: $(DPKGS)
$(DPKGS):
	mkdir -p $@$(TGT_LIB)
	cp $(LOC_LIB_DIR)/$(LIBNAME).so $@$(TGT_LIB)/$(LIBNAME).so.$(MAJ_VERSION)
	cp $(LOC_LIB_DIR)/$(LIBNAME).a $@$(TGT_LIB)/$(LIBNAME).so.$(MAJ_VERSION)
	ln -s $(LIBNAME).so.$(MAJ_VERSION) $@$(TGT_LIB)/$(LIBNAME).so
	ln -s $(LIBNAME).a.$(MAJ_VERSION) $@$(TGT_LIB)/$(LIBNAME).a
	mkdir -p $@$(TGT_CONF)
	cp zlog.conf $@$(TGT_CONF)/default.zlog
	mkdir -p $@/DEBIAN
	@if [[ $@ == *-dev ]]; then \
		mkdir -p $@$(TGT_INCLUDE); \
		cp $(LOC_INC_DIR)/* $@$(TGT_INCLUDE)/.; \
		echo "cp $(LOC_INC_DIR)/* $@$(TGT_INCLUDE)/."; \
		cp $(DPKG_CTL_DIR)/control-dev $@/DEBIAN/control; \
	else \
		cp $(DPKG_CTL_DIR)/control $@/DEBIAN/control; \
	fi
	sed -i 's/<version>/$(VERSION)/g' $@/DEBIAN/control
	sed -i 's/<maj_version>/$(MAJ_VERSION)/g' $@/DEBIAN/control
	dpkg-deb -b $@

dpkg-clean:
	rm -rf $(DPKG_DIR)
