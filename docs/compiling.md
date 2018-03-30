How To Compile, Or Not
======================

1.0 Use As Pure Tcl - No Compilation Required
---------------------------------------------

The Wapp framework is pure Tcl contained in a single file called
"[wapp.tcl](/file/wapp.tcl)".  That, and a generic "tclsh",
is all you need to run a Wapp application.

For example, when testing Wapp, the developers run the following command from
the root of the source tree:

>
    tclsh tests/test01.tcl

The [test01.tcl](/file/tests/test01.tcl) script does a "source ../wapp.tcl" to
load the Wapp framework.  No special interpreter is required.

The [search function](https://sqlite.org/search) of the SQLite homepage takes
this one step further.  The Tcl script that implements the search function embeds
the wapp.tcl script when the website is built.  The "wapp.tcl" is neither
"source"-ed nor "package require"-ed.  The wapp.tcl script is embedded into the
"search" script.

2.0 Using A Special Interpreter
-------------------------------

It is sometimes convenient to use the special "wapptclsh" interpreter to run
Wapp applications.  The "wapptclsh" works just like ordinary "tclsh" with the
following minor differences:

  +  Wapptclsh understands "package require wapp" natively, without any extra
     finagling.

  +  Wapptclsh comes with SQLite built-in.  SQLite turns out to be very handy
     for the kinds of small web applications that Wapp  is designed for.

  +  Wapptclsh builds are (by default) statically linked, so that it works inside
     chroot jails that lack all the shared libraries needed by generic "tclsh".

To reiterate: "wapptclsh" is not required to run Wapp applications.  But it is
convenient.  The developer of Wapp prefers using "wapptclsh" on his installations.

2.1 Compiling The Special Interpreter
-------------------------------------

To build wapptclsh, make a copy of either Makefile or Makefile.macos in the
top-level directory of the source tree.  Change a few settings.  (This step is
not hard as each Makefile is less than 20 lines long.)  Then run the Makefile.

There is no configure script or other automation to help do the build.  Maybe
we will add one someday.  But for now, the Makefile is simple enough to work
stand-alone.
