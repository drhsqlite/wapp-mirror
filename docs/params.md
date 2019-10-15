Wapp Parameters
===============

The purpose of a Wapp invocation is to answer an HTTP request.
That HTTP request is described by various "parameters".

Each parameter has a key and a value.

The Wapp application retrieves the value for the parameter with
key _NAME_ using a call to [wapp-param _NAME_].
If there is no parameter with the key _NAME_, then the wapp-param
function returns an empty string.
Or, if wapp-param is given a second argument, the value of the second 
argument is returned if there exists no parameter with a key of _NAME_.

1.0 Parameter Types
-------------------

Each request has four different kinds or sources of parameters:

  1.  **CGI Parameters**  
      Parameters with upper-case names contain information about the
      HTTP request as it was received by the web server.  Examples of
      CGI parameters are CONTENT\_LENGTH which is the number of bytes
      of content in the HTTP request, REMOTE\_ADDR which holds the IP
      address from which the HTTP request originated, REQUEST\_URI which
      is the path component of the URL that caused the HTTP request,
      and many others.  Many of the CGI Parameters have names that
      are the same as the traditional environment variables used to
      pass information into CGI programs - hence the name "CGI Parameters".
      However, with Wapp these values are not necessarily environment
      variables and they all exist regardless of whether the application
      is run using CGI, via SCGI, or using the built-in web server.

  2.  **Cookies**  
      If the HTTP request contained cookies, Wapp automatically decodes
      the cookies into new Wapp parameters.
      Only cookies that have lower-case names are decoded.  This
      prevents a cookie name from colliding with a CGI parameter.
      Cookies that have uppercase letters in their name are silently
      ignored.

  3.  **Query Parameters**  
      Query parameters are the key/value arguments that follow the "?"
      in the URL of the HTTP request.  Wapp automatically decodes the
      key/value pairs and makes a new Wapp parameter for each one.
      <p>
      Only query parameter that have lower-case names are decoded.  This
      prevents a query parameter from overriding or impersonating a
      CGI parameter.  Query parameter with upper-case letters in their
      name are silently ignored.  Furthermore, query parameters are only
      decoded if the HTTP request uses the same origin as the application,
      or if the "wapp-allow-xorigin-params" has been run to signal Wapp
      that cross-origin query parameters are allowed.

  4.  **POST Parameters**  
      POST parameters are the application/x-www-form-urlencoded key/value
      pairs in the content of a POST request that typically originate from
      forms.  POST parameters are treated exactly like query parameters in
      that they are decoded to form new Wapp parameters as long as they
      have all lower-case keys and as long as either the HTTP request comes
      from the same origin or the "wapp-allow-xorigin-params" command has
      been run.
      
All Wapp parameters are held in a single namespace.  There is no way to
distinguish a cookie from a query parameter from a POST parameter.  CGI
parameters can be distinguished from the others by having all upper-case
names.

1.1 Parameter Examples
----------------------

To better understand how parameters work in Wapp, run the 
"[env.tcl](/file/examples/env.tcl)" sample application in the
[examples](/file/examples) folder of the source repository.  Like this:

>   
     wapptclsh examples/env.tcl

The command above should cause a web page to pop up in your web browser.
That page will look something like this:

>**Wapp Environment**
>
    BASE_URL = http://127.0.0.1:33999
    DOCUMENT_ROOT = /home/drh/wapp/examples
    HTTP_ACCEPT_ENCODING = {gzip, deflate}
    HTTP_COOKIE = {env-cookie=simple}
    HTTP_HOST = 127.0.0.1:33999
    HTTP_USER_AGENT = {Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101 Firefox/59.0}
    PATH_HEAD = {}
    PATH_INFO = {}
    PATH_TAIL = {}
    QUERY_STRING = {}
    REMOTE_ADDR = 127.0.0.1
    REMOTE_PORT = 53060
    REQUEST_METHOD = GET
    REQUEST_URI = /
    SAME_ORIGIN = 0
    SCRIPT_FILENAME = /home/drh/wapp/examples/env.tcl
    SCRIPT_NAME = {}
    SELF_URL = http://127.0.0.1:33999/
    WAPP_MODE = local
    env-cookie = simple
    [pwd] = /home/drh/wapp

Try this.  Then modify the URL by adding new path elements and query
parameters to see how this affects the Wapp parameters.
Notice in particular how query parameters are decoded and added to the
set of Wapp parameters.

2.0 Security By Default
-----------------------

Parameter values in the original HTTP request may be encoded in various
ways.  Wapp decodes parameter values before returning them to the
application.  Application developers never see the encoded values.
There is never an opportunity to miss a decoding step.

For security reasons, Query and POST parameters are only added to the
Wapp parameter set if the inbound request is from the "same origin" or
if the special "wapp-allow-xorigin-params" interface is called.
An inbound request is from the same origin if it is in response to
clicking on a hyperlink or form on a page that was generated by the
same website.
Manually typing in a URL does not constitute the "same origin".  Hence,
in the "env.tcl" example above the "wapp-allow-xorigin-params" interface
is used so that you can manually extend the URL to add new query parameters.

If query parameters can have side effects, then you should omit the
wapp-allow-xorigin-params call.  The wapp-allow-xorigin-params command
is safe for read-only web pages.  Do not invoke wapp-allow-xorigin-params
on pages where the parameters can be used to change server state.

<a name='cgidetail'></a>
3.0 CGI Parameter Details [(Quick reference)](quickref.md#cgiparams)
-------------------------

The CGI parameters in Wapp describe the HTTP request that is to be answered
and the execution environment.
These parameter look like CGI environment variables.  To prevent environment
information from overlapping and overwriting query parameters, all the
environment information uses upper-case names and all query parameters
are required to be lower case.  If an input URL contains an upper-case
query parameter (or POST parameter or cookie), that parameter is silently
omitted.

The following CGI parameters are available:

  +  **CONTENT\_LENGTH**  
     The number of bytes of POST data.
     This parameter is either omitted or has a value of "0"
     for non-POST requests.

  +  **CONTENT\_TYPE**  
     The mimetype of the POST data.  Usually this is
     application/x-www-form-urlencoded.
     This parameter is omitted for non-POST requests.

  +  **DOCUMENT\_ROOT**  
     For CGI or SCGI, this parameter is the name a directory on the server
     that is the root of the static content tree.  When running a Wapp script
     using the built-in web server, this is the name of the directory that
     contains the script.

  +  **HTTP\_COOKIE**  
     The values of all cookies in the HTTP header.
     This parameter is omitted if there are no cookies.

  +  **HTTP\_HOST**  
     The hostname (or IP address) and port that the client used to create
     the current HTTP request.  This is the first part of the request URL,
     right after the "http://" or "https://".  The format for this value
     is "HOST:PORT".  Examples:  "sqlite.org:80" or "127.0.0.1:32172".
     Some servers omit the port number if it has a value of 80.

  +  **HTTP\_USER\_AGENT**  
     The name of the web-browser or other client program that generated
     the current HTTP request, as reported in the User-Agent header.

  +  **HTTPS**  
     If the HTTP request arrived of SSL (via "https://"), then this variable
     has the value "on".  For an unencrypted request ("http://"), this
     parameter is undefined.

  +  **PATH\_INFO**  
     The part of the URL path that follows the SCRIPT\_NAME.  For all modes
     other than CGI, this is exactly the URL pathname, though with the
     query parameters removed.  PATH_INFO begins with a "/".

  +  **REMOTE\_ADDR**  
     The IP address from which the HTTP request originated.

  +  **REMOTE\_PORT**  
     The TCP port from which the HTTP request originated.

  +  **REQUEST\_METHOD**  
     "GET" or "HEAD" or "POST"

  +  **REQUEST\_URI**  
     The URL for the inbound request, without the initial "http://" or
     "https://" and without the HTTP\_HOST.  This variable is the same as
     the concatenation of $SCRIPT\_NAME and $PATH\_INFO.

  +  **SCRIPT\_FILENAME**  
     The full pathname on the server for the Wapp script.  This parameter
     is usually undefined for SCGI.

  +  **SCRIPT\_NAME**  
     In CGI mode, this is the name of the CGI script in the URL.  In other
     words, this is the initial part of the URL path that identifies the
     CGI script.  When using the built-in webserver, the value of this
     parameter is an empty string.  For SCGI, this parameter is normally
     undefined.


All of the above are standard CGI environment values.
The following are supplemental environment parameters are added by Wapp:


  +  **BASE\_URL**  
     The text of the request URL through the SCRIPT\_NAME.  This value can
     be prepended to hyperlinks to ensure that the correct page is reached by
     those hyperlinks.

  +  **CONTENT**  
     The raw POST data text.

  +  **PATH\_HEAD**  
     The first element in the PATH\_INFO.  The value of PATH\_HEAD is used to
     select one of the "wapp-page-XXXXX" commands to run in order to generate
     the output web page.

  +  **PATH\_TAIL**  
     All of PATH\_INFO that follows PATH\_HEAD.

  +  **SAME\_ORIGIN**  
     This value is either "1" or "0" depending on whether the current HTTP
     request is a follow-on to another request from this same website or not.
     Query parameters and POST parameters are usually only decoded and added
     to Wapp's parameter list if SAME\_ORIGIN is 1.  If a webpage implemented
     by Wapp needs access to query parameters for a cross-origin request, then
     it should invoke the "wapp-allow-xorigin-params" interface to explicitly
     signal that cross-origin parameters are safe for that page.

  +  **SELF\_URL**  
     The URL for the current page, stripped of query parameter. This is
     useful for filling in the action= attribute of forms.

  +  **SERVER\_ADDR**  
     In SCGI mode only, this variable is the address of the webserver from which
     the SCGI request originates.

  +  **WAPP\_MODE**  
     This parameter has a value of "cgi", "local", "scgi", or "server" depending
     on how Wapp was launched.


### 3.1 URL Parsing Example

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
extensions.  The following is the same information show in a diagram:

>
    http://example.com/cgi-bin/script/method/extra/path?q1=5
           \_________/\_____________/\________________/ \__/
                |            |               |           |
            HTTP_HOST   SCRIPT_NAME      PATH_INFO       `-- QUERY_STRING

>
    http://example.com/cgi-bin/script/method/extra/path?q1=5
           \_________/\_______________________________/ \__/
                |                    |                   |
            HTTP_HOST         REQUEST_URI                `-- QUERY_STRING

>
    http://example.com/cgi-bin/script/method/extra/path?q1=5
    \_______________________________/ \____/ \________/
                    |                    |        | 
                BASE_URL           PATH_HEAD   PATH_TAIL


>
    http://example.com/cgi-bin/script/method/extra/path?q1=5
    \______________________________________/ \________/
                       |                          |
                    SELF_URL                   PATH_TAIL

### 3.2 Undefined Parameters When Using SCGI on Nginx

Some of the CGI parameters are undefined by default when using SCGI mode
with Nginx.  If these CGI parameters are needed by the application, then
values must be assigned in the Nginx configuration file.  For example:

>
    location /scgi/ {
       include scgi_params;
       scgi_pass localhost:9000;
       scgi_param SCRIPT_NAME "/scgi";
       scgi_param SCRIPT_FILENAME "/home/www/scgi/script1.tcl";
    }
