Wapp - A Web-Application Framework for TCL
==========================================

1.0 Introduction
----------------

Wapp is a framework for writing web applications in TCL.
Wapp has the following advantages:

  *   Small API surface &rarr; Simple to learn and use
  *   Efficient
  *   Self-contained
  *   Resistant to attacks and exploits
  *   Yields applications that are trival to enhance and maintain
  *   Cross-platform - works with any web server, or runs stand-alone
  *   A complete application is contained in a single TCL script
  *   The Wapp framework itself is also just a single TCL script
      that is "source"-ed, "package require"-ed, 
      or even copy/pasted into the application TCL script


2.0 The Problem That Wapp Attempts To Solve
-------------------------------------------

Do you ever need
a simple script to provide a list of files (such as on a download page),
or small app to manage conference room scheduling for the office, or
a few simple pages to monitor or manage the status of a server?
These sorts of problems are traditionally handled with ad-hoc
CGI scripts using libraries that decode the HTTP request and
safely encoding the reply.  This presents a number of problems:

  *   A single application typically involves multiple files.  There
      will be CSS and javascript files and other resources, plus at
      least one file for each distinct URI serviced by the application.
      This makes long-term maintenance difficult because people lose
      track of which files in the web hierarchy belong to which applications.

  *   The implementation will typically only work with a single
      stack.  Case in point:  the web interface for the MailMan
      mailing list manager only works on Apache, so if you are running
      something different you are out of luck.

  *   Because the implementation is tied to a single stack, the
      application development environment must mirror the deployment
      environment.  To debug or enhance an application running on
      web server X, the developer must set up an instance of X on the
      development machine, or else do risky development work directly
      on the production machine.

  *   Great care is required to safely decoding HTTP parameters and
      encoding HTML and JSON, so as to avoid injection attacks.
      A single slip-up can result in a vulnerability.

Wapp seeks to overcome these problems by providing a mechanism to create
powerful applications contained within a single file of easily-readable
TCL script.  Deployment options are flexible:

  1.  During development, a Wapp application can be run from the
      command-line, using a built-in web server listening on the
      loopback IP addrss.  Whenever Wapp is run in this mode, it
      also automatically brings up the start page for the application
      in the systems default web browser.

  2.  The built-in web-server in Wapp can also be used in deployment
      by having it listen on a low-numbered port and on public facing
      IP addresses.

  3.  Wapp applications can be run as CGI on systems like Apache.

  4.  Wapp applications can be run as SCGI on systems like Nginx.

All four deployment options use the same application code and present the
same interface to the application user.  Method (1) is normally used during
development and maintenance.  After testing, the single script file
that implements
the application is pushed out to servers for deployment using one of 
options (2), (3), or (4).  In this way, Wapp applications are easy to 
manage and are not tied to any particular web stack.

Wapp applications are inheriently resistant against XSS and CSRF attacks.
Safety features such as safe parameter decoding and HTML/JSON encoding and
Content Security Policy (CSP) are enabled by default.  This enables
developers to spend more time working on the application, and less
time worrying about whether or not they have introduced some security
hole by failing to safely encode or decode content.

3.0 Further information
-----------------------

  *  [Introduction To Writing Wapp Applications](docs/intro.md)

  *  [Wapp Parameters](docs/params.md)

  *  [Wapp Commands](docs/commands.md)

  *  [Security Features](docs/security.md)

  *  [Limitations of Wapp](docs/limitations.md)

  *  [Example Applications](/file/examples)

  *  [Real-World Uses Of Wapp](docs/usageexamples.md)
