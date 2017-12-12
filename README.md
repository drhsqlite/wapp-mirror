Wapp - A Web-Application Framework for TCL
========================================

1.0 Introduction
----------------

Wapp is a simple and lightweight framework that strives to simplify the
construction of web application written in TCL. The same Wapp application
can be launched in multiple ways:

  *  From the command-line (ex: <tt>tclsh app.tcl</tt>).  In this mode,
     The wapp-app find an available TCL port on localhost, starts an
     in-process web server listening on that port, and then launches the 
     users default web browser directed at localhost:$port

  *  As a CGI program

  *  As an SCGI program

  *  As a stand-alone web server

All four methods of launching the application provide the same interface
to the user.

1.0 Hello World!
----------------

Wapp is designed to be easy to use.  A hello-world program is as follows:

>
    package require wapp
    proc wapp-default {req} {
       wapp "<h1>Hello, World!</h1>\n"
    }
    wapp-start $::argv

The application defines one or more procedures that accept HTTP requests.
For an HTTP request where the initial portion of the URI is "abcde", the
procedure named "wapp-page-abcde" will be invoked to construct the reply.
If no such procedure exists, "wapp-default" is invoked instead.

The procedure generates a reply using one or more calls to the "wapp"
command.  Each "wapp" command appends new text to the reply.

The "wapp-start" command starts up the built-in web server.

To run this application, but the code above into a file named "main.tcl"
and then run type "<tt>tclsh main.tcl</tt>" at the command-line.  That
should cause the "Hello, World!" page to appear in your web browser.


### 1.1 A Slightly Longer Example

Information about each HTTP request is encoded in the global ::wapp
dict variable.  The following sample program shows the information
available in ::wapp.

>
    package require wapp
    proc wapp-default {} {
      global wapp
      wapp "<h1>Hello, World!</h1>\n"
      wapp-unsafe "<p>See the <a href='[dict get $wapp BASE_URL]/env'>Wapp "
      wapp "Environment</a></p>"
    }
    proc wapp-page-env {} {
      global wapp
      wapp "<h1>Wapp Environment</h1>\n"
      wapp "<pre>\n"
      foreach var [lsort [dict keys $wapp]] {
        if {[string index $var 0]=="."} continue
        wapp-escape-html "$var = [list [dict get $wapp $var]]\n"
      }
      wapp "</pre>"
    }
    wapp-start $::argv

In this application, the default "Hello, World!" page has been extended
with a hyperlink to the /env page.  The "wapp-unsafe" command works exactly
the same as "wapp" (it appends its argument text to the web page under
construction) except that the argument to "wapp-unsafe" is allowed to contain
TCL variable and command expansions.  The "wapp" command will generate a
warning if its argument contains TCL variable or command expansions, as a
defense against accidental XSS vulnerabilities.

The /env page is implemented by the "wapp-page-env" proc.  This proc
generates an HTML unordered list where each element of the list describes
a single value in the global ::wapp dict.  The "wapp-escape-html"
command is like "wapp" and "wapp-unsafe" except that "wapp-escape-html"
escapes HTML markup so that it displays correctly in the output.

### 1.2 The ::wapp Global Dict

To better understand how the ::wapp dict works, try running the previous
sample program, but extend the /env URL with extra path elements and query
parameters.  For example:
[http://localhost:8080/env/longer/path?q1=5&title=hello+world%21]

Notice how the query parameters in the input URL are decoded and become
elements of the ::wapp dict.  The same thing occurs with POST parameters
and cookies - they are all converted into entries in the ::wapp dict
variable so that the parameters are easily accessible to page generation
procedures.

The ::wapp variable contains additional information about the request,
roughly corresponding to CGI environment variables.  To prevent environment
information from overlapping and overwriting query parameters, all the
environment information uses upper-case names and all query parameters
are required to be lower case.  If an input URL contains an upper-case
query parameter (or POST parameter or cookie), that parameter is silently
omitted from the ::wapp variable

The ::wapp variable contains the following environment values:

  +  **HTTP_HOST**  
     The hostname (or IP address) and port that the client used to create
     the current HTTP request.  This is the first part of the request URL.

  +  **HTTP_USER_AGENT**  
     The name of the web-browser or other client program that generated
     the current HTTP request.

  +  **HTTPS**  
     If the HTTP request arrived of SSL, then this variable has the value "on".
     For an unencrypted request, the variable does not exist.

  +  **REMOTE_ADDR**  
     The IP address and port from which the HTTP request originated.

  +  **SCRIPT_NAME**  
     In CGI mode, this is the name of the CGI script in the URL.  In other
     words, it is the initial part of the URL path that identifies the
     CGI script.  For other modes, this variable is an empty string.

  +  **PATH_INFO**  
     The part of the URL path that follows the SCRIPT_NAME.  For all modes
     other than CGI, this is exactly the URL pathname.

  +  **REQUEST_URI**  
     The URL for the inbound request, without the initial "http://" or
     "https://" and without the HTTP_HOST.

  +  **REQUEST_METHOD**  
     "GET" or "HEAD" or "POST"

  +  **BASE_URL**  
     The text of the request URL through the SCRIPT_NAME.  This value can
     be prepended to hyperlinks to ensure that the correct page is reached by
     those hyperlinks.

  +  **PATH_HEAD**  
     The first element in the PATH_INFO.  The value of PATH_HEAD is used to
     select one of the "wapp-page-XXXXX" commands to run in order to generate
     the output web page.

  +  **PATH_TAIL**  
     All of PATH_INFO that follows PATH_HEAD.

  +  **SELF_URL**  
     The URL for the current page, stripped of query parameter. This is
     useful for filling in the action= attribute of forms.
 

### 1.3 Additional Wapp Commands

The following utility commands are available for use by applications built
on Wapp:

  +  **wapp-start** _ARGLIST_  
     Start up the application.  _ARGLIST_ is typically the value of $::argv,
     though it might be some subset of $::argv if the containing application
     has already processed some command-line parameters for itself.

  +  **wapp** _TEXT_  
     Add _TEXT_ to the web page output currently under construction.  _TEXT_
     must not contain any TCL variable or command substitutions.

  +  **wapp-unsafe** _TEXT_  
     Add _TEXT_ to the web page under construction even though _TEXT_ does
     contain TCL variable and command substitutions.  The application developer
     must ensure that the variable and command substitutions does not allow
     XSS attacks.

  +  **wapp-encode-html** _TEXT_  
     Add _TEXT_ to the web page under construction after first escaping any
     HTML markup contained with _TEXT_.

  +  **wapp-encode-url** _TEXT_  
     Add _TEXT_ to the web page under construction after first escaping any
     characters so that the result is safe to include as the value of a
     query parameter on a URL.

  +  **wapp-mimetype** _MIMETYPE_  
     Set the MIME-type for the generated web page.  The default is "text/html".

  +  **wapp-reply-code** _CODE_
     Set the reply-code for the HTTP request.  The default is "200 Ok".

  +  **wapp-redirect** _TARGET-URL_  
     Cause an HTTP redirect to the specified URL.

  +  **wapp-reset**  
     Reset the web page under construction back to an empty string.

  +  **wapp-set-cookie** \[-path _PATH_\] \[-expires _DAYS_\] _NAME_ _VALUE_  
     Cause the cookie _NAME_ to be set to _VALUE_.

  +  **wapp-send-hex** _HEX_  
     Cause the HTTP reply to be binary that is constructed from the
     hexadecimal text in the _HEX_ argument.  Whitespace in _HEX_ is ignored.
     This command is useful for returning small images from a pure script
     input.  The "wapp-file-to-hex" command can be used at development time
     to generate appropriate _HEX_ for an image file.

  +  **wapp-cache-control** _CONTROL_  
     The _CONTROL_ argument should be one of "no-cache", "max-age=N", or
     "private,max-age=N", where N is an integer number of seconds.

  +  **wapp-etag** _ETAG_  
     Set the expiration tag for the web page.

  +  **wapp-send-file** _FILENAME_  
     Make the content of the file _FILENAME_ be the HTTP reply.

  +  **wapp-send-query** _DB_ _SQL_  
     Run the SQLite query _SQL_ on the _DB_ database connection and make the
     HTTP reply be the value of the first column of the first row in the result.

  +  **wapp-set-csp** _POLICY_  
     Set the Content Security Policy for the application.  This command only
     works for command-line and server modes.  This command is a no-op for CGI
     and SCGI since there is no standard way of communicating the desired
     content security policy back to the server in those instances.

  +  **wapp-debug-port** _PORT_  
     For debugging use only: open a listening TCP socket on _PORT_ and run
     an interactive TCL shell on connections to that port.  This allows for
     interactive debugging of a running instance of the Wapp server.  This
     command is a no-op for short-lived CGI programs, obviously.  Also, this
     command should only be used during debugging, as otherwise it introduces
     a severe security vulnerability into the application.

  *  **wapp-safety-check**  
     Examine all TCL procedures in the application and report errors about
     unsafe usage of "wapp".

### 1.4 Design Rules

All global procs and variables used by Wapp begin with the four character
prefix "wapp".  Procs and variable intended for internal use begin with
the seven character prefix "wappInt".
