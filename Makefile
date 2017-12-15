#!/usr/bin/make

CC = gcc -Os -static
TCLLIB = /home/drh/tcl/lib/libtcl8.6.a -lm -lz -lpthread -ldl
TCLINC = /home/drh/tcl/include
TCLSH = tclsh

all: wapptclsh

wapptclsh: wapptclsh.c
	$(CC) -I. -I$(TCLINC) -o $@ wapptclsh.c $(TCLLIB)

wapptclsh.c:	wapptclsh.c.in wapp.tcl wapptclsh.tcl tclsqlite3.c mkccode.tcl
	$(TCLSH) mkccode.tcl wapptclsh.c.in >$@

clean:	
	rm wapptclsh wapptclsh.c
