#!/usr/bin/make

CC = gcc -Os -static
TCLLIB1 = 
TCLLIB2 = /home/drh/tcl/lib/libtcl8.7.a -lm -lz -lpthread -ldl
TCLINC = /home/drh/tcl/include
TCLSH = tclsh

# Comment out the following to disable TLS support.
#
# The tcltls.a library can be build from sources obtained from
#
#      https://core.tcl-lang.org/tcltls/wiki/Download
#
# Use "./configure --disable-shared".  You will also need to install static
# OpenSSL libraries.
#
CC += -DWAPP_ENABLE_TCLTLS
TCLLIB1 = /home/drh/tcl/lib/tcltls.a -lssl -lcrypto

all: wapptclsh

wapptclsh: wapptclsh.c
	$(CC) -I. -I$(TCLINC) -o $@ wapptclsh.c $(TCLLIB1) $(TCLLIB2)

wapptclsh.c:	wapptclsh.c.in wapp.tcl wapptclsh.tcl tclsqlite3.c mkccode.tcl
	$(TCLSH) mkccode.tcl wapptclsh.c.in >$@

clean:	
	rm -f wapptclsh wapptclsh.c
