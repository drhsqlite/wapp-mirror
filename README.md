Wapp - A Web-Application Framework for TCL
==========================================

1.0 Introduction
----------------

Wapp is a new framework for writing web applications in TCL,
with the following advantages:

  *   Very small API surface &rarr; Simple to learn and use
  *   A complete application is contained in a single file
  *   Resistant to attacks and exploits
  *   Cross-platform &rarr; Works via CGI, SCGI, or using a built-in web server
  *   Does not require MVC, but can do MVC if desired
  *   The Wapp framework itself is a  single-file TCL script
      that is "source"-ed, "package require"-ed, 
      or even copy/pasted into the application TCL script


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
move into the appropriate directory of your web server.

3.0 Further information
-----------------------

  *  [Introduction To Writing Wapp Applications](docs/intro.md)

  *  [Quick Reference](docs/quickref.md)

  *  [Wapp Parameters](docs/params.md)

  *  [Wapp Commands](docs/commands.md)

  *  [URL Mapping](docs/urlmapping.md)

  *  [Security Features](docs/security.md)

  *  [Limitations of Wapp](docs/limitations.md)

  *  [Example Applications](/file/examples)

  *  [Real-World Uses Of Wapp](docs/usageexamples.md)
