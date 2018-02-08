Example Applications
====================

1.0 env.tcl
-----------

This is a very simple script that can used as a starter template for a
larger application.  All it does is show the CGI environment of each
web request.  Run it like this:

>
    wapptclsh env.tcl

You can add additional path terms and/or query parameters to the URL in
your browser to see how this affects the parameter values.


2.0 formajax01.tcl and formajax02.tcl
-------------------------------------

These scripts demonstrate how to use XMLHttpRequest with Wapp to send
form data back to the server.  The formajax01.tcl script sends back the
form data as JSON and formajax02.tcl sends the data as
application/x-www-form-urlencoded.  The form data received by the server
is printed on standard output.

To run these examples:

>
    wapptclsh formajax01.tcl
    wapptclsh formajax02.tcl

3.0 tableajax01.tcl
-------------------

This script demonstrates how a button click on a webpage can be used to fetch
additional HTML text from the server (a &lt;table&gt; in this case) and 
insert that new HTML at some position within the DOM.  To run this script:

>
    wapptclsh tableajax01.tcl

See comments in the script source code for additional information.

4.0 shoplist.tcl
----------------

This is an actual application used by the Wapp author's family to keep
track of grocery lists.  To run it, enter

>
    wapptclsh shoplist.tcl -DDBFILE=shoplist-demo.db

The "shoplist-demo.db" is a demonstration database for testing purposes.
The "-DDBFILE=shoplist-demo.db" argument causes the global TCL variable
named "DBFILE" to be overwritten with the value of "shoplist-demo.db",
for testing purposes.  For actual deployment of this script, you would
want to modify the script to set the DBFILE variable to the correct
database name.

The password for the "shoplist-demo.db" database is "12345".

When the app is running, the /env page shows the CGI environment for
debugging and testing purposes.

5.0 self.tcl
------------

This script gives an example of a Wapp application that can display
a copy of itself.  The self-display in the /self page is actually
a very small part of the total script.  This example also includes
some cache-control and CSS as a demonstration of how that kind of thing
is accomplished.
