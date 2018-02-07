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
tradition CGI and SCGI, and Wapp, break a URL down like this:

>
    https://wapp.tcl.tk/demo/env.tcl/abc/def/ghi?a=5&b=22.425#point42
            \_________/ \__________/\__________/
                 |           |          |
             HTTP_HOST  SCRIPT_NAME  PATH_INFO

>
    https://wapp.tcl.tk/demo/env.tcl/abc/def/ghi?a=5&b=22.425#point42
    \______________________________/ \_/ \_____/
                   |                  |     |
                BASE_URL         PATH_HEAD  '-- PATH_TAIL     

>
    https://wapp.tcl.tk/demo/env.tcl/abc/def/ghi?a=5&b=22.425#point42
    \__________________________________/         \__________/
                   |                                  |
                SELF_URL                         QUERY_STRING


2.0 URL Mapping
---------------

The URL Mapper is the function that determines which routine in the
application should handle an HTTP request based on the URL.  In Wapp,
the default URL Mapper simply looks at PATH_HEAD and invokes the
application-defined proc name "wapp-page-$PATH_HEAD".  If no such
proc exists, then Wapp invokes the application-defined proc "wapp-default".

2.1 Customizing The URL Mapper
------------------------------

Just prior to dispatch of the HTTP request handler, Wapp invokes a
proc named "wapp-before-dispatch-hook".  This proc is normally a no-op.
But, applications can redefine the "wapp-before-dispatch-hook" proc to
make modifications to the environment prior to dispatch.  So, for example,
a custom wapp-before-dispatch-hook function can change the value of
the PATH_HEAD parameter to cause a different request handler to be invoked.

The [checklist](https://sqlite.org/checklistapp) application does this.
See [these lines](https://sqlite.org/checklistapp/artifact/8f94882fa0?ln=715-744)
for the implementation.  If the original PATH\_HEAD is really the name of
a checklist database, then that name is moved to a new parameter called
OBJECT, and PATH\_HEAD is shifted to be the next element of PATH_TAIL.
In this way, the PATH\_INFO for checklist is parsed into OBJECT/METHOD
rather than just a METHOD.

This is but one example.  Applications can make creative use of
the "wapp-before-dispatch-hook" to make whatever changes are appropriate
for the task at hand.
