Wapp Quick Reference
====================

1.0 Application Template
------------------------

>
    package require wapp
    proc wapp-page-XXXXX {} {
      wapp-trim {
        # Content to deliver for page XXXXX
      }
    }
    proc wapp-default {} {
      wapp-trim {
        # Content for all other pages
      }
    }
    wapp-start $argv
         

2.0 Interfaces
--------------

>
|**wapp-start** $argv|&rarr;|Starts up the Wapp application|
|**wapp-subst** {_TEXT_}|&rarr;|Append _TEXT_ to the output with substitution|
|**wapp-trim** {_TEXT_}|&rarr;|Like **wapp-subst** but also removes left-margin whitespace|
|**wapp-param** _NAME_ _DEFAULT_|&rarr;|Return value of parameter _NAME_|
|**wapp-set-param** _NAME_ _VALUE_|&rarr;|Set parameter _NAME_ to _VALUE_|
|**wapp-param-exists** _NAME_|&rarr;|True if parameter _NAME_ exists|
|**wapp-param_list** _GLOB_|&rarr;|Return parameter names matching _GLOB_|
|**wapp-allow-xorigin-params**|&rarr;|Allow GET and POST parameters for cross-origin requests|
|**wapp-mimetype** _MIMETYPE_|&rarr;|Set the reply mimetype|
|**wapp-reply-code** _CODE_|&rarr;|Set the HTTP reply code|
|**wapp-redirect** _TARGET_|&rarr;|Redirect to _TARGET_|
|**wapp-reset**|&rarr;|Reset the output back to an empty string|
|**wapp-set-cookie** _NAME_ _VALUE_|&rarr;|Set cookie _NAME_ to have _VALUE_|
|**wapp-clear-cookie** _NAME_|&rarr;|Delete cookie _NAME_|
|**wapp-cache-control** _CONTROL_|&rarr;|Set caching behavior of current page|
|**wapp-content-security-policy** _POLICY_|&rarr;|Set the CSP for the current page|
|**wapp-debug-env**|&rarr;|Return a text description of the Wapp environment|
|**wapp** {_TEXT_}|&rarr;|Append _TEXT_ without substitution|
|**wapp-unsafe** _TEXT_|&rarr;|Append _TEXT_ that contains nothing that needs to be escaped|


<a name="cgiparams"></a>
3.0 CGI Parameters [(More detail)](params.md#cgidetail)
------------------

>
|BASE\_URL|&rarr;|URL for the Wapp script without a method|
|CONTENT|&rarr;|Raw (unparsed) POST content|
|CONTENT\_LENGTH|&rarr;|Number of bytes of raw, unparsed POST content|
|CONTENT\_TYPE|&rarr;|Mimetype of the POST content|
|DOCUMENT\_ROOT|&rarr;|Directory that is the root of the webserver content tree|
|HTTP\_COOKIE|&rarr;|Raw, unparsed cookies|
|HTTP\_HOST|&rarr;|Hostname to which this request was sent|
|HTTP\_USER\_AGENT|&rarr;|Name of client program that sent current request|
|HTTPS|&rarr;|Exists and has value "on" if the request is TLS encrypted|
|PATH\_HEAD|&rarr;|First element of PATH\_INFO. Determines request handler|
|PATH\_INFO|&rarr;|URL path beyond the application script name|
|PATH\_TAIL|&rarr;|Part of PATH\_INFO beyond PATH\_HEAD|
|REMOTE\_ADDR|&rarr;|IP address of the client|
|REMOTE\_PORT|&rarr;|TCP port of the client|
|REQUEST\_METHOD|&rarr;|"GET" or "POST" or "HEAD"|
|SAME\_ORIGIN|&rarr;|True if this request is from the same origin|
|SCRIPT\_FILENAME|&rarr;|Full pathname of the Wapp application script|
|SCRIPT\_NAME|&rarr;|Prefix of PATH\_INFO that identifies the application script|
|SELF\_URL|&rarr;|URL of this request without PATH\_TAIL|
|WAPP\_MODE|&rarr;|One of "cgi", "scgi", "server", or "local"|

4.0 URL Parsing
---------------

Assuming "env.tcl" is the name of the Wapp application script:

>
    https://wapp.tcl.tk/demo/env.tcl/abc/def/ghi?a=5&b=22.425#point42
            \_________/\___________/\__________/ \__________/
                 |           |          |             |
             HTTP_HOST  SCRIPT_NAME  PATH_INFO    QUERY_STRING

>
    https://wapp.tcl.tk/demo/env.tcl/abc/def/ghi?a=5&b=22.425#point42
    \______________________________/ \_/ \_____/
                   |                  |     |
                BASE_URL         PATH_HEAD  `-- PATH_TAIL

>
    https://wapp.tcl.tk/demo/env.tcl/abc/def/ghi?a=5&b=22.425#point42
    \__________________________________/         \__________/
                   |                                  |
                SELF_URL                         QUERY_STRING

>
    SCRIPT_FILENAME := DOCUMENT_ROOT + SCRIPT_NAME
