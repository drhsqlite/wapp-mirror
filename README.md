Wapp - A Web-Application Framework for TCL
==========================================

1.0 Introduction
----------------

Wapp is a framework for writing web applications in TCL,
with the following advantages:

  *   Very small API &rarr; easy to learn and use
  *   A complete application is contained in a single file
  *   Resistant to attacks and exploits
  *   Cross-platform &rarr; CGI, SCGI, or a built-in web server
  *   The MVC design pattern is supported but not required
  *   The Wapp framework itself is a  single-file TCL script
      that is "source"-ed, "package require"-ed, 
      or even copy/pasted into the application TCL script
  *   The framework can easily be embedded within a larger application
      to provide a web-based monitoring capability to an existing
      code base
  *   2-clause BSD license


2.0 Hello World
---------------

Here is a minimal web application written using Wapp:

>
    #!/usr/bin/tclsh
    package require wapp
    proc wapp-default {} {
      wapp-subst {<h1>Hello, World!</h1>\n}
    }
    wapp-start $argv

To run this application using the built-in web-server, store the code above
in a file (here we use the name "hello.tcl") and do:

>
    tclsh hello.tcl

To run the app using the built-in web-server bound to all TCP addresses
and listening on port 8080, use:

>
    tclsh hello.tcl --server 8080

To run the app as an SCGI server listening on port 9001:

>
    tclsh hello.tcl --scgi 9001

To run the application as CGI, make the hello.tcl file executable and
move it into the appropriate directory of the web server.

3.0 Further information
-----------------------

  *  [Introduction To Writing Wapp Applications](/doc/trunk/docs/intro.md)
  *  [Quick Reference](/doc/trunk/docs/quickref.md)
  *  [Wapp Parameters](/doc/trunk/docs/params.md)
  *  [Wapp Commands](/doc/trunk/docs/commands.md)
  *  [URL Mapping](/doc/trunk/docs/urlmapping.md)
  *  [Security Features](/doc/trunk/docs/security.md)
  *  [How To Compile wapptclsh - Or Not](/doc/trunk/docs/compiling.md)
  *  [Limitations of Wapp](/doc/trunk/docs/limitations.md)
  *  [Example Applications](/file/examples)
  *  [Real-World Uses Of Wapp](/doc/trunk/docs/usageexamples.md)
  *  [Debugging Hints](/doc/trunk/docs/debughints.md)
