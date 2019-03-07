URL Mapping In Wapp
===================

1.0 Anatomy Of A URL
--------------------

A Uniform Resource Locator (URL) is divided into parts as follows:

>
    https://wapp.tcl.tk/demo/env.tcl/abc/def/ghi?a=5&b=22.425#point42
    \___/   \_________/ \______________________/ \__________/ \_____/
      |          |              |                     |          |
    scheme   authority        path                  query      fragment


Assuming that /demo/env.tcl is the script that implements the application,
traditional CGI and SCGI provide the following breakdown:

>
    https://wapp.tcl.tk/demo/env.tcl/abc/def/ghi?a=5&b=22.425#point42
            \_________/ \__________/\__________/ \__________/
                 |           |          |             |
             HTTP_HOST  SCRIPT_NAME  PATH_INFO   QUERY_STRING

Wapp provides additional variables not found in traditional CGI:

>
                SELF_URL
     ______________|___________________
    /                                  \
    https://wapp.tcl.tk/demo/env.tcl/abc/def/ghi?a=5&b=22.425#point42
    \______________________________/ \_/ \_____/
                   |                  |     |
                BASE_URL         PATH_HEAD  '-- PATH_TAIL     


2.0 URL Mapping
---------------

The URL Mapper is the function that determines which routine in the
application should handle an HTTP request based on the URL.  In Wapp,
the default URL Mapper simply looks at PATH\_HEAD and invokes the
application-defined proc name "wapp-page-$PATH\_HEAD".  If no such
proc exists, then Wapp invokes the application-defined proc "wapp-default".

2.1 Customizing The URL Mapper
------------------------------

Just prior to dispatch of the HTTP request handler, Wapp invokes a
proc named "wapp-before-dispatch-hook".  This proc is normally a no-op.
But, applications can redefine the "wapp-before-dispatch-hook" proc to
make modifications to the environment prior to dispatch.  So, for example,
a custom wapp-before-dispatch-hook function can change the value of
the PATH\_HEAD parameter to cause a different request handler to be invoked.

The [checklist](https://sqlite.org/checklistapp) application does this.
See [these lines](https://sqlite.org/checklistapp/artifact/8f94882fa0?ln=715-744)
for the implementation.  If the original PATH\_HEAD is really the name of
a checklist database, then that name is moved to a new parameter called
OBJECT, and PATH\_HEAD is shifted to be the next element of PATH\_TAIL.
In this way, the PATH\_INFO for checklist is parsed into OBJECT/METHOD
rather than just a METHOD.

This is but one example.  Applications can make creative use of
the "wapp-before-dispatch-hook" to make whatever changes are appropriate
for the task at hand.
