Wapp - A Web-Application Framework for TCL
==========================================

1.0 Introduction
----------------

Wapp is a lightweight framework that simplifies the
construction of web application written in TCL. The same Wapp-based
application can be launched in multiple ways:

  1.  From the command-line, with automatic web-browser startup

  2.  As a stand-alone web server

  3.  As a CGI script

  4.  As an SCGI program

All four methods use the exact same application code and present the same
interface to the application user.  An application can be developed on
the desktop using stand-alone mode (1), then deployed as a stand-alone
server (2), or a CGI script (3), or as an SCGI program (4).

2.0 Hello World!
----------------

Wapp is designed to be easy to use.  A hello-world program is as follows:

>
    package require wapp  ;# OR source wapp.tcl
    proc wapp-default {req} {
       wapp "<h1>Hello, World!</h1>\n"
    }
    wapp-start $::argv

The application defines one or more procedures that accept HTTP requests
and generate appropriate replies.
For an HTTP request where the initial portion of the URI is "abcde", the
procedure named "wapp-page-abcde" will be invoked to construct the reply.
If no such procedure exists, "wapp-default" is invoked instead.  The latter
technique is used for the hello-world example above.

The procedure generates a reply using one or more calls to the "wapp"
command.  Each "wapp" command appends new text to the reply.

The "wapp-start" command starts up the application.

To run this application, copy the code above into a file named "main.tcl"
and then enter the following command:

>
    tclsh main.tcl

That command will start up a web-server bound to the loopback
IP address, then launch a web-browser pointing at that web-server.
The result is that the "Hello, World!" page will automatically
appear in your web browser.

To run this same program as a traditional web-server on TCP port 8080, enter:

>
    tclsh main.tcl --server 8080

Here the built-in web-server listens on all IP addresses and so the
web page is available on other machines.  But the web-broswer is not
automatically started in this case, so you will have to manually enter
"http://localhost:8080/" into your web-browser in order to see the page.

To run this program as CGI, put the main.tcl script in your web-servers
file hierarchy, in the appropriate place for CGI scripts, and make any
other web-server specific configuration changes so that the web-server
understands that the main.tcl file is a CGI script.  Then point your
web-browser at that script.

Run the hello-world program as SCGI like this:

>
    tclsh main.tcl --scgi 9000

Then configure your web-server to send SCGI requests to TCL port 9000
for some specific URI, and point your web-browser at that URI.

3.0 A Slightly Longer Example
-----------------------------

Information about each HTTP request is encoded in the global ::wapp
dict variable.  The following sample program shows the information
available in ::wapp.

>
    package require wapp
    proc wapp-default {} {
      global wapp
      wapp "<h1>Hello, World!</h1>\n"
      set B [dict get $wapp BASE_URL]
      wapp-subst {<p>See the <a href='%html($B)/env'>Wapp }
      wapp "Environment</a></p>"
    }
    proc wapp-page-env {} {
      global wapp
      wapp "<h1>Wapp Environment</h1>\n"
      wapp "<pre>\n"
      foreach var [lsort [dict keys $wapp]] {
        if {[string index $var 0]=="."} continue
        wapp-subst {%html($var) = %html([list [dict get $wapp $var]])\n}
      }
      wapp "</pre>"
    }
    wapp-start $::argv

In this application, the default "Hello, World!" page has been extended
with a hyperlink to the /env page.  The "wapp-subst" command works like "wapp"
in that it appends its argument text to the web page under construction.
But "wapp-subst" also does safe substitutions of text.  Within the "wapp-subst"
argument, "%html(...)" is replaced by the expansion of "..." which has been
escaped for safe inclusion in HTML text.  Similarly, "%url(...)" is replaced
by "..." after it has been expanded and escaped for use as a URL query
parameter.  The argument to "wapp-subst" should always be enclosed in
{...}.  Backslash substitutions are performed automatically.

The /env page is implemented by the "wapp-page-env" proc.  This proc
generates HTML that describes the content of the ::wapp dict.
Keys that begin with "." are for internal use by Wapp and are skipped
for this display.  Notice the use of "wapp-subst" to safely escape text
for inclusion in an HTML document.

4.0 The ::wapp Global Dict
--------------------------

To better understand how the ::wapp dict works, try running the previous
sample program, but extend the /env URL with extra path elements and query
parameters.  For example:
<http://localhost:8080/env/longer/path?q1=5&title=hello+world%21>

Notice how the query parameters in the input URL are decoded and become
elements of the ::wapp dict.  The same thing occurs with POST parameters
and cookies - they are all converted into entries in the ::wapp dict
variable so that the parameters are easily accessible to page generation
procedures.

The ::wapp dict contains additional information about the request,
roughly corresponding to CGI environment variables.  To prevent environment
information from overlapping and overwriting query parameters, all the
environment information uses upper-case names and all query parameters
are required to be lower case.  If an input URL contains an upper-case
query parameter (or POST parameter or cookie), that parameter is silently
omitted from the ::wapp dict.

The ::wapp dict contains the following environment values:

  +  **HTTP\_HOST**  
     The hostname (or IP address) and port that the client used to create
     the current HTTP request.  This is the first part of the request URL,
     right after the "http://" or "https://".  The format for this value
     is "HOST:PORT".  Examples:  "sqlite.org:80" or "127.0.0.1:32172".

  +  **HTTP\_USER\_AGENT**  
     The name of the web-browser or other client program that generated
     the current HTTP request.

  +  **HTTP\_COOKIE**  
     The values of all cookies in the HTTP header

  +  **HTTPS**  
     If the HTTP request arrived of SSL (via "https://"), then this variable
     has the value "on".  For an unencrypted request ("http://"), this
     variable does not exist.

  +  **REMOTE\_ADDR**  
     The IP address from which the HTTP request originated.

  +  **REMOTE\_PORT**  
     The TCP port from which teh HTTP request originated.

  +  **SCRIPT_NAME**  
     In CGI mode, this is the name of the CGI script in the URL.  In other
     words, this is the initial part of the URL path that identifies the
     CGI script.  For other modes, this variable is an empty string.

  +  **PATH\_INFO**  
     The part of the URL path that follows the SCRIPT\_NAME.  For all modes
     other than CGI, this is exactly the URL pathname, though with the
     query parameters removed.  PATH_INFO begins with a "/".

  +  **REQUEST\_URI**  
     The URL for the inbound request, without the initial "http://" or
     "https://" and without the HTTP\_HOST.  This variable is the same as
     the concatenation of $SCRIPT\_NAME and $PATH\_INFO.

  +  **REQUEST\_METHOD**  
     "GET" or "HEAD" or "POST"

  *  **CONTENT\_LENGTH**  
     The number of bytes of POST data.

  *  **CONTENT\_TYPE**  
     The mimetype of the POST data.  Usually this is
     application/x-www-form-urlencoded.


All of the above are standard CGI environment values.
The following are additional values add by Wapp:


  *  **CONTENT**  
     The raw POST data text.

  +  **BASE\_URL**  
     The text of the request URL through the SCRIPT\_NAME.  This value can
     be prepended to hyperlinks to ensure that the correct page is reached by
     those hyperlinks.

  +  **PATH\_HEAD**  
     The first element in the PATH\_INFO.  The value of PATH\_HEAD is used to
     select one of the "wapp-page-XXXXX" commands to run in order to generate
     the output web page.

  +  **PATH\_TAIL**  
     All of PATH\_INFO that follows PATH\_HEAD.

  +  **SELF\_URL**  
     The URL for the current page, stripped of query parameter. This is
     useful for filling in the action= attribute of forms.


### 4.1 URL Parsing Example

For the input URL "http://example.com/cgi-bin/script/method/extra/path?q1=5"
and for a CGI script named "script" in the /cgi-bin/ directory, 
the following CGI environment values are generated:

  +  **HTTP\_HOST** &rarr; "example.com:80"
  +  **SCRIPT\_NAME** &rarr; "/cgi-bin/script"
  +  **PATH\_INFO** &rarr; "/method/extra/path"
  +  **REQUEST\_URI** &rarr; "/cgi-bin/script/method/extra/path"
  +  **QUERY\_STRING** &rarr; "q1=5"
  +  **BASE\_URL** &rarr; "http://example.com/cgi-bin/script"
  +  **SELF\_URL** &rarr; "http://example.com/cgi-bin/script/method"
  +  **PATH\_HEAD** &rarr; "method"
  +  **PATH\_TAIL** &rarr; "extra/path"

The first five elements of the example above, HTTP\_HOST through
QUERY\_STRING, are standard CGI.  The final four elements are Wapp
extensions.

5.0 Wapp Commands
-----------------

The following utility commands are available for use by applications built
on Wapp:

  +  **wapp-start** _ARGLIST_  
     Start up the application.  _ARGLIST_ is typically the value of $::argv,
     though it might be some subset of $::argv if the containing application
     has already processed some command-line parameters for itself.

  +  **wapp** _TEXT_  
     Add _TEXT_ to the web page output currently under construction.  _TEXT_
     must not contain any TCL variable or command substitutions.

  +  **wapp-subst** _TEXT_  
     The _TEXT_ argument should be enclosed in {...} to prevent substitutions.
     The "wapp-subst" command itself will do all necessary backslash
     substitutions.  Command and variable substitutions only occur within
     "%html(...)" and "%url(...)" and the results are safely escaped for
     inclusion in the body of an HTML document or as a query parameter.

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

  *  **wapp-safety-check**  
     Examine all TCL procedures in the application and report errors about
     unsafe usage of "wapp".

  +  **wapp-unsafe** _TEXT_  
     Add _TEXT_ to the web page under construction even though _TEXT_ does
     contain TCL variable and command substitutions.  The application developer
     must ensure that the variable and command substitutions does not allow
     XSS attacks.  Avoid using this command.  The use of "wapp-subst" is 
     preferred in most situations.

  +  **wapp-encode-html** _TEXT_  
     Add _TEXT_ to the web page under construction after first escaping any
     HTML markup contained with _TEXT_.  This command is equivalent to
     "wapp-subst {%html(_TEXT_)}".


  +  **wapp-encode-url** _TEXT_  
     Add _TEXT_ to the web page under construction after first escaping any
     characters so that the result is safe to include as the value of a
     query parameter on a URL.  This command is equivalent to
     "wapp-subst {%url(_TEXT_)}".


The following additional interfaces are envisioned, but are not yet
implemented:

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

6.0 Design Rules
----------------

All global procs and variables used by Wapp begin with the four character
prefix "wapp".  Procs and variable intended for internal use begin with
the seven character prefix "wappInt".
