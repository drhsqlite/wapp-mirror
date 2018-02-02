Developing Applications Using Wapp
==================================

You can use whatever development practices you are comformable with.  But
if you want some hints for getting started, consider the following:

  1.  Compile the "wapptclsh" executable.  You do not need a separate
      interpreter to run Wapp.  A standard "tclsh" will work fine.  But
      "wapptclsh" contains the a built-in copy of "wapp.tcl" and it
      has SQLite compiled in.  We find it convenient to use.  The sequel
      will assume you have "wapptclsh" somewhere on your $PATH.

  2.  Seed your application using one of the templates scripts in
      the [examples](/file/examples) folder of this repository.  Verify
      that you can run the template and that it works.

  3.  Make a few simple changes to the code.

  4.  Run "wapptclsh yourcode.tcl" to test your changes.  Use the --trace
      option to list each HTTP request URI as it is encountered.  Use the
      --lint option to scan the application code for dodgy constructs that
      might be a security problem.

  5.  Goto 3.  Continue looping until your application does what you want.

  6.  Move the application script to your server for deployment.

During the loop between steps (3) and (5), there is no web server sitting
in between the application and your browser, which means there is no
translation or interpretation of traffic.  This can help make debugging
easier.  Also, you can add "puts" commands to the application to get
interactive debugging in the shell that ran the "wapptclsh yourcode.tcl"
command while the application is running.
