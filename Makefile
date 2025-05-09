SHELL := /bin/bash
SRC_NAME = zlog

include config.mk

LOC_INC_DIR = $(SRC_NAME)/src
LOC_LIB_DIR = $(SRC_NAME)/src

LIB_VERSION = $(VMAJ).$(VMIN)
LIB_VERSION_SRC = 1.2

LLIBNAME = lib$(LIBNAME)
VLIBNAME = $(LLIBNAME)-$(LIB_VERSION)
LLIBNAME_SRC = lib$(SRC_NAME)
VLIBNAME_SRC = $(LLIBNAME_SRC)-$(LIB_VERSION_SRC)
SONAME_SRC = $(LLIBNAME_SRC).so.$(LIB_VERSION_SRC)
PKGNAME = $(LLIBNAME)$(LIB_VERSION)

TGT_INCLUDE = $(DESTDIR)/usr/include/smx/$(VLIBNAME)
TGT_LIB = $(DESTDIR)/usr/lib/x86_64-linux-gnu/$(VLIBNAME)
TGT_LD = $(DESTDIR)/etc/ld.so.conf.d
TGT_DOC = $(DESTDIR)/usr/share/doc/$(LLIBNAME)$(LIB_VERSION)
TGT_CONF = $(DESTDIR)/etc/smx/$(LLIBNAME)$(LIB_VERSION)
TGT_LOG = $(DESTDIR)/var/log/smx

INCLUDES = $(LOC_INC_DIR)/*.h

all:
	$(MAKE) -C zlog

.PHONY: clean install uninstall

install:
	mkdir -p $(TGT_LIB) $(TGT_INCLUDE) $(TGT_CONF) $(TGT_LOG) $(TGT_LD)
	cp -a $(INCLUDES) $(TGT_INCLUDE)/.
	cp -a $(LOC_LIB_DIR)/*.so* $(TGT_LIB)/.
	ln -sf $(LLIBNAME_SRC).so $(TGT_LIB)/$(VLIBNAME).so
	echo $(TGT_LIB) > $(TGT_LD)/$(PKGNAME).conf
	cp tpl/default.zlog $(TGT_CONF)/default.zlog

uninstall:
	rm -rf $(TGT_LIB)
	rm -rf $(TGT_INCLUDE)
	rm -rf $(TGT_CONF)
	rm -f $(TGT_LD)/$(PKGNAME).conf

clean:
	$(MAKE) clean -C zlog
