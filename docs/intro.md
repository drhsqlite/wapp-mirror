Introducing To Writing Wapp Applications
========================================

1.0 Hello World
---------------

Wapp applications are easy to develop.  A hello-world program is as follows:

>
    #!/usr/bin/wapptclsh
    package require wapp
    proc wapp-default {req} {
       wapp-subst {<h1>Hello, World!</h1>\n}
    }
    wapp-start $::argv

Every Wapp application defines one or more procedures that accept HTTP
requests and generate appropriate replies.
For an HTTP request where the initial portion of the URI path is "abcde", the
procedure named "wapp-page-abcde" will be invoked to construct the reply.
If no such procedure exists, "wapp-default" is invoked instead.  The latter
technique is used for the hello-world example above.

The hello-world example generates the reply using a single call to the "wapp-subst"
command.  Each "wapp-subst" command appends new text to the reply, applying
various substitutions as it goes.  The only substitution in this example is
the \\n at the end of the line.

The "wapp-start" command starts up the application.

1.1 Running A Wapp Application
------------------------------

To run this application, copy the code above into a file named "main.tcl"
and then enter the following command:

>
    wapptclsh main.tcl

That command will start up a web-server bound to the loopback
IP address, then launch a web-browser pointing at that web-server.
The result is that the "Hello, World!" page will automatically
appear in your web browser.

To run this same program as a traditional web-server on TCP port 8080, enter:

>
    wapptclsh main.tcl --server 8080

Here the built-in web-server listens on all IP addresses and so the
web page is available on other machines.  But the web-brwser is not
automatically started in this case, so you will have to manually enter
"http://localhost:8080/" into your web-browser in order to see the page.

To run this program as CGI, put the main.tcl script in your web-servers
file hierarchy, in the appropriate place for CGI scripts, and make any
other web-server specific configuration changes so that the web-server
understands that the main.tcl file is a CGI script.  Then point your
web-browser at that script.

Run the hello-world program as SCGI like this:

>
    wapptclsh main.tcl --scgi 9000

Then configure your web-server to send SCGI requests to TCL port 9000
for some specific URI, and point your web-browser at that URI.

1.2 Using Plain Old Tclsh
-------------------------

Wapp applications are pure TCL code.  You can run them using an ordinary
"tclsh" command if desired, instead of the "wapptclsh" shown above.  We
normally use "wapptclsh" for the following reasons:

   +  Wapptclsh is statically linked, so there is never a worry about
      having the right shared libraries on hand.  This is particularly
      important if the application will ultimately be deployed into a
      chroot jail.

   +  Wapptclsh has SQLite built-in and SQLite turns out to be very
      useful for the kinds of small application where Wapp excels.

   +  Wapptclsh knows how to process "package require wapp".  If you
      run with ordinary tclsh, you might need to change the 
      "package require wapp" into "source wapp.tcl" and ship the separate
      "wapp.tcl" script together with your application.

We prefer to use wapptclsh and wapptclsh is shown in all of the examples.
But ordinary "tclsh" will work in the examples too.

2.0 Longer Examples
-------------------

Wapp keeps track of various [parameters](params.md) that describe
each HTTP request.  Those parameters are accessible using routines
like "wapp-param _NAME_"
The following sample program gives some examples:

>
    package require wapp
    proc wapp-default {} {
      set B [wapp-param BASE_URL]
      wapp-trim {
        <h1>Hello, World!</h1>
        <p>See the <a href='%html($B)/env'>Wapp
        Environment</a></p>
      }
    }
    proc wapp-page-env {} {
      wapp-allow-xorigin-params
      wapp-subst {<h1>Wapp Environment</h1>\n<pre>\n}
      foreach var [lsort [wapp-param-list]] {
        if {[string index $var 0]=="."} continue
        wapp-subst {%html($var) = %html([list [wapp-param $var]])\n}
      }
      wapp-subst {</pre>\n}
    }
    wapp-start $argv

In this application, the default "Hello, World!" page has been extended
with a hyperlink to the /env page.  The "wapp-subst" command has been
replaced by "wapp-trim", which works the same way with the addition that
it removes surplus whitespace from the left margin, so that the generated
HTML text does not come out indented.  The "wapp-trim" and "wapp-subst"
commands in this example use "%html(...)" substitutions.  The "..." argument 
is expanded using the usual TCL rules, but then the result is escaped so
that it is safe to include in an HTML document.  Other supported
substitutions are "%url(...)" for
URLs on the href= and src= attributes of HTML entities, "%qp(...)" for
query parameters, "%string(...)" for string literals within javascript,
and "%unsafe(...)" for direct literal substitution.  As its name implies,
the %unsafe() substitution should be avoid whenever possible.

The /env page is implemented by the "wapp-page-env" proc.  This proc
generates HTML that describes all of the query parameters. Parameter names
that begin with "." are for internal use by Wapp and are skipped
for this display.  Notice the use of "wapp-subst" to safely escape text
for inclusion in an HTML document.

The printing of all the parameters as is done by the /env page turns
out to be so useful that there is a special "wapp-debug-env" command
to render the text for us.  Using "wapp-debug-env", the program
above can be simplified to the following:

>
    package require wapp
    proc wapp-default {} {
      set B [wapp-param BASE_URL]
      wapp-trim {
        <h1>Hello, World!</h1>
        <p>See the <a href='%html($B)/env'>Wapp
        Environment</a></p>
      }
    }
    proc wapp-page-env {} {
      wapp-allow-xorigin-params
      wapp-trim {
        <h1>Wapp Environment</h1>\n<pre>
        <pre>%html([wapp-debug-env])</pre>
      }
    }
    wapp-start $argv

Most Wapp applications contain an /env page for debugging and
trouble-shooting purpose.  Examples:
<https://sqlite.org/checklists/env> and
<https://sqlite.org/search?env=1>


2.1 Binary Resources
--------------------

Here is another variation on the same "hello, world" program that adds an
image to the main page:

>
    package require wapp
    proc wapp-default {} {
      set B [wapp-param BASE_URL]
      wapp-trim {
        <h1>Hello, World!</h1>
        <p>See the <a href='%html($B)/env'>Wapp
        Environment</a></p>
        <p>Broccoli: <img src='broccoli.gif'></p>
      }
    }
    proc wapp-page-env {} {
      wapp-allow-xorigin-params
      wapp-trim {
        <h1>Wapp Environment</h1>\n<pre>
        <pre>%html([wapp-debug-env])</pre>
      }
    }
    proc wapp-page-broccoli.gif {} {
      wapp-mimetype image/gif
      wapp-cache-control max-age=3600
      wapp-unsafe [binary decode base64 {
        R0lGODlhIAAgAPMAAAAAAAAiAAAzMwBEAABVAABmMwCZMzPMM2bMM5nMM5nMmZn/
        mczMmcz/mQAAAAAAACH5BAEAAA4ALAAAAAAgACAAAAT+0MlJXbmF1M35VUcojNJI
        dh5YKEbRmqthAABaFaFsKG4hxJhCzSbBxXSGgYD1wQw7mENLd1FOMa3nZhUauFoY
        K/YioEEP4WB1pB4NtJMMgTCoe3NWg2lfh68SCSEHP2hkYD4yPgJ9FFwGUkiHij87
        ZF5vjQmPO4kuOZCIPYsFmEUgkIlJOVcXAS8DSVoxB0xgA6hqAZaksiCpPThghwO6
        i0kBvb9BU8KkASPHfrXAF4VqSgAGAbpwDgRSaqQXrLwDCF5CG9/hpJKkb17n6RwA
        18To7whJX0k2NHYjtgXoAwCWPgMM+hEBIFDguDrjZCBIOICIg4J27Lg4aGCBPn0/
        FS1itJdNX4OPChditGOmpIGTMkJavEjDzASXMFPO7IAT5M6FBvQtiPnTX9CjdYqi
        cFlgoNKlLbbJfLqh5pAIADs=
      }]
    }
    wapp-start $argv

This application is the same as the previous except that it adds the
"broccoli.gif" image on the main "Hello, World" page.  The image file is
a separate resource, which is provided by the new "wapp-page-broccoli.gif"
proc.  The image is a GIF which has been encoded using base64 so that
it can be put into an text TCL script.  The "[binary decode base64 ...]"
command is used to convert the image back into binary before returning
it.

Other resources might be added using procs like "wapp-page-style.css"
or "wapp-page-script.js".

3.0 General Structure Of A Wapp Application
-------------------------------------------

Wapp applications all follow the same basic template:

>
    package require wapp;
    proc wapp-page-XXXXX {} {
      # code to generate page XXXXX
    }
    proc wapp-page-YYYYY {} {
      # code to generate page YYYYY
    }
    proc wapp-default {} {
      # code to generate any page not otherwise
      # covered by wapp-page-* procs
    }
    wapp-start $argv

The application script first loads the Wapp code itself using
the "package require" at the top.  (Some applications may choose
to substitute "source wapp.tcl" to accomplish the same thing.)
Next the application defines various procs that will generate the
replies to HTTP requests.  Different procs are invoked based on the
first element of the URI past the Wapp script name.  Finally,
the "wapp-start" routine is called to start Wapp running.  The
"wapp-start" routine never returns (or in the case of CGI, it only
returns after the HTTP request has been completely processed), 
so it should be the very last command in the application script.

3.1 Wapp Applications As Model-View-Controller
----------------------------------------------

If you are accustomed to thinking of web applications using the
Model-View-Controller (MVC) design pattern, Wapp supports that
point of view.  A basic template for an MVC Wapp application
is like this:

>
    package require wapp;
    # procs to implement the model go here
    proc wapp-page-XXXXX {} {
      # code to implement controller for XXXXX
      # code to implement view for XXXXX
    }
    proc wapp-page-YYYYY {} {
      # code to implement controller for YYYYY
      # code to implement view for YYYYY
    }
    proc wapp-default {} {
      # code to implement controller for all other pages
      # code to implement view for all other pages
    }
    wapp-start $argv

The controller and view portions of each page need not be coded
together into the same proc.  They can each be sub-procs that
are invoked from the main proc, if separating the functions make
code clearer.

So Wapp does support MVC, but without a lot of complex
machinary and syntax.
