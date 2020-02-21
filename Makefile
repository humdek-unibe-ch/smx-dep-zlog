SHELL := /bin/bash

include config.mk

LOC_INC_DIR = zlog/src
LOC_LIB_DIR = zlog/src

LLIBNAME = lib$(LIBNAME)
LIB_VERSION = $(VMAJ).$(VMIN)
UPSTREAM_VERSION = $(LIB_VERSION).$(VREV)
DEBIAN_REVISION = $(VDEB)
VERSION = $(UPSTREAM_VERSION)-$(DEBIAN_REVISION)

VLIBNAME = $(LLIBNAME)-$(LIB_VERSION)
SOSRC = $(LLIBNAME).so.1.2
SOTGT = $(LLIBNAME).so.$(LIB_VERSION)
ANAME = $(LLIBNAME).a

TGT_INCLUDE = $(DESTDIR)/usr/include/smx
TGT_LIB = $(DESTDIR)/usr/lib/x86_64-linux-gnu
TGT_DOC = $(DESTDIR)/usr/share/doc/$(LLIBNAME)$(LIB_VERSION)
TGT_CONF = $(DESTDIR)/etc/smx/$(LLIBNAME)$(LIB_VERSION)
TGT_LOG = $(DESTDIR)/var/log/smx

STATLIB = $(LOC_LIB_DIR)/$(LLIBNAME).a
DYNLIB = $(LOC_LIB_DIR)/$(LLIBNAME).so

INCLUDES = $(LOC_INC_DIR)/*.h

all:
	$(MAKE) -C zlog

.PHONY: clean install uninstall

install:
	mkdir -p $(TGT_LIB) $(TGT_INCLUDE) $(TGT_CONF) $(TGT_LOG)
	cp -a $(INCLUDES) $(TGT_INCLUDE)/.
	cp -a $(LOC_LIB_DIR)/$(SOSRC) $(TGT_LIB)/$(SOTGT)
	ln -sf $(SOTGT) $(TGT_LIB)/$(VLIBNAME).so
	ln -sf $(SOTGT) $(TGT_LIB)/$(LLIBNAME).so
	cp tpl/default.zlog $(TGT_CONF)/default.zlog

uninstall:
	rm $(addprefix $(TGT_INCLUDE)/,$(notdir $(wildcard $(INCLUDES))))
	rm $(TGT_LIB)/$(SOTGT)
	rm $(TGT_LIB)/$(LLIBNAME).so
	rm $(TGT_LIB)/$(VLIBNAME).so
	rm $(TGT_CONF)/default.zlog

clean:
	$(MAKE) clean -C zlog
