Wapp - A Web-Application Framework for TCL
==========================================

1.0 Introduction
----------------

Wapp is a framework for writing utility web applications in TCL.
Wapp has the following advantages:

  *   Simple to use
  *   A complete application in a single short script file
  *   Robust against attack
  *   Efficient
  *   Trival to enhance and maintain
  *   Cross-platform - works with any web server, or stand-alone


2.0 The Problem That Wapp Attempts To Solve
-------------------------------------------

Do you ever have a situation where you need
a simple script to provide a list of files (such as on a download page),
or small app to manage conference room scheduling for the office, or
a few simple pages to monitor or manage the status of a server?
These sorts of problems are traditionally handled with ad-hoc
CGI scripts implemented using libraries that provide utilities
for decoding the HTTP request and safely encoding the reply.  This
presents a number of problems:

  *   A single application typically involves multiple files.  There
      will be CSS and javascript files and other resources, plus at
      least one file for each distinct URI serviced by the application.
      This makes long-term maintenance is difficult because people lose
      track of which files in the web hierarchy belong to which applications.

  *   The implementation will typically only work with a single
      stack.  Case in point:  the web interface for the MailMan
      mailing list manager only works on Apache, so if you are running
      something different you are out of luck.

  *   Decoding HTTP parameters safely, and encoding HTML and Javascript
      safely, so as to avoid injection attacks, requires great
      care on the part of the application developer.  A single slip-up
      can result in a vulnerability.

Wapp seeks to overcome these problems by providing a mechanism to create
powerful applications contained within a single file of easily-readable
TCL script.  Deployment options are flexible:

  1.  During development, a Wapp application can be run from the
      command-line, using a built-in web server, and automatically
      bringing up a page in the developers web-browser that shows
      the start page of the application.

  2.  The built-in web-server in Wapp can also be used in deployment
      by having it listen on a low-numbered port and on public facing
      IP addresses.

  3.  Wapp applications can be run as CGI on systems like Apache.

  4.  Wapp applications can be run as SCGI on systems like Nginx.

All four deployment options use the same application code and present the
same interface to the application user.  Method (1) is normally used during
development and maintenance, then the single script file that implements
the application is pushed out to servers for deployment using one of 
options (2), (3), or (4).  In this way, Wapp applications are easy to 
manage and are not tied to any particular web stack.

Wapp applications are inheriently resistant against XSS and CSRF attacks.
Safety features such as safe parameter decoding and HTML encoding and
Content Security Policy (CSP) are enabled by default.  Developers can
spend more time focusing on the application, and less time worrying about
whether or not they have introduced some security hole by failing to 
safely encode or decode data.

3.0 Further information
-----------------------

  *  [Introduction To Writing Wapp Applications](docs/intro.md)

  *  [Wapp Parameters](docs/params.md)

  *  [Wapp Commands](docs/commands.md)

  *  [Security Considerations](docs/security.md)

  *  [Limitations of Wapp](docs/limitations.md)

  *  [Example Applications](/file/examples)
