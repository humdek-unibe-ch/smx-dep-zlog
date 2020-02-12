SHELL := /bin/bash

include config.mk

LOC_INC_DIR = zlog/src
LOC_LIB_DIR = zlog/src

LIB_VERSION = $(VMAJ).$(VMIN)
UPSTREAM_VERSION = $(LIB_VERSION).$(VREV)
DEBIAN_REVISION = 0
VERSION = $(UPSTREAM_VERSION)-$(DEBIAN_REVISION)

VLIBNAME = $(LIBNAME)-$(LIB_VERSION)
SONAME = $(LIBNAME).so.$(LIB_VERSION)
ANAME = $(LIBNAME).a

TGT_INCLUDE = $(DESTDIR)/usr/include/smx
TGT_LIB = $(DESTDIR)/usr/lib/x86_64-linux-gnu
TGT_DOC = $(DESTDIR)/usr/share/doc/smx
TGT_CONF = $(DESTDIR)/usr/etc/smx
TGT_LOG = $(DESTDIR)/var/log/smx

STATLIB = $(LOC_LIB_DIR)/$(LIBNAME).a
DYNLIB = $(LOC_LIB_DIR)/$(LIBNAME).so

INCLUDES = $(LOC_INC_DIR)/*.h

all:
	$(MAKE) -C zlog/.

.PHONY: clean install uninstall

install:
	mkdir -p $(TGT_LIB) $(TGT_INCLUDE) $(TGT_CONF) $(TGT_LOG)
	cp -a $(INCLUDES) $(TGT_INCLUDE)/.
	cp -a $(LOC_LIB_DIR)/$(LIBNAME).so $(TGT_LIB)/$(SONAME)
	ln -sf $(SONAME) $(TGT_LIB)/$(VLIBNAME).so
	ln -sf $(SONAME) $(TGT_LIB)/$(LIBNAME).so
	cp tpl/default.zlog $(TGT_CONF)/default.zlog

uninstall:
	rm $(addprefix $(TGT_INCLUDE)/,$(notdir $(wildcard $(INCLUDES))))
	rm $(TGT_LIB)/$(SONAME)
	rm $(TGT_LIB)/$(LIBNAME).so
	rm $(TGT_LIB)/$(VLIBNAME).so
	rm $(TGT_CONF)/default.zlog

clean:
	$(MAKE) clean -C zlog
