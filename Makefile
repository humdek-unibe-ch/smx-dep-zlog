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

TGT_INCLUDE = $(DESTDIR)/usr/include/smx/$(VLIBNAME)
TGT_LIB = $(DESTDIR)/usr/lib/x86_64-linux-gnu/$(VLIBNAME)
TGT_DOC = $(DESTDIR)/usr/share/doc/$(LLIBNAME)$(LIB_VERSION)
TGT_CONF = $(DESTDIR)/etc/smx/$(LLIBNAME)$(LIB_VERSION)
TGT_LOG = $(DESTDIR)/var/log/smx

INCLUDES = $(LOC_INC_DIR)/*.h

all:
	$(MAKE) -C zlog

.PHONY: clean install uninstall

install:
	mkdir -p $(TGT_LIB) $(TGT_INCLUDE) $(TGT_CONF) $(TGT_LOG)
	cp -a $(INCLUDES) $(TGT_INCLUDE)/.
	cp -a $(LOC_LIB_DIR)/$(SONAME_SRC) $(TGT_LIB)/.
	ln -sf $(SONAME_SRC) $(TGT_LIB)/$(VLIBNAME_SRC).so
	ln -sf $(SONAME_SRC) $(TGT_LIB)/$(LLIBNAME_SRC).so
	cp tpl/default.zlog $(TGT_CONF)/default.zlog

uninstall:
	rm $(addprefix $(TGT_INCLUDE)/,$(notdir $(wildcard $(INCLUDES))))
	rm $(TGT_LIB)/$(SONAME_SRC)
	rm $(TGT_LIB)/$(LLIBNAME_SRC).so
	rm $(TGT_LIB)/$(VLIBNAME_SRC).so
	rm $(TGT_CONF)/default.zlog

clean:
	$(MAKE) clean -C zlog
