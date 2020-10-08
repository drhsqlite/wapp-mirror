#!/usr/bin/wapptclsh
#
# This script demonstrates the use of the wapp-before-reply-hook interface.
#
# The wapp-before-reply-hook is a TCL proc that runs just before the reply
# to an HTTP request is generated.  It has the opportunity to review the
# HTTP reply to ensure that no sensitive information is present in the
# reply, due to accidents or bugs in the code.  It can modify the reply
# or generate an error.
#
# Most applications omit the wapp-before-reply-hook in which case it is
# a no-op.
#
# This demo is the "self.tcl" demo, with a wapp-before-reply-hook added
# that changes all instances of the string "before-reply" into "XXXXXXXXXXXX".
#
package require wapp
proc wapp-before-reply-hook {} {
  global wapp
  dict set wapp .reply \
    [string map {before-reply XXXXXXXXXXXX} [dict get $wapp .reply]]
}
proc common-header {} {
  wapp-trim {
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link href="%url([wapp-param SCRIPT_NAME]/style.css)" rel="stylesheet">
    <title>Wapp Self-Display Demo</title>
    </head>
    <body>
  }
}
proc common-footer {} {
  wapp-trim {
    </body>
    </html>
  }
}
proc wapp-default {} {
  wapp-cache-control max-age=3600
  common-header
  wapp-trim {
    <h1>Wapp Self-Display Demo</h1>
    <p>(Strings "&#98;efore-reply" changed into "XXXXXXXXXXXX".)</p>
    <ul>
    <li> <a href='%url([wapp-param SCRIPT_NAME])/self'>Show the script
    that generates this page</a>
    <li> <a href='%url([wapp-param SCRIPT_NAME])/env'>Wapp Environment</a>
    </ul>
  }
  common-footer
}
proc wapp-page-env {} {
  wapp-allow-xorigin-params
  common-header
  wapp-trim {
    <h1>Wapp Environment</h1>
    <pre>%html([wapp-debug-env])</pre>
  }
  common-footer
}
proc wapp-page-self {} {
  wapp-cache-control max-age=3600
  common-header
  set fd [open [wapp-param SCRIPT_FILENAME] rb]
  set script [read $fd]
  close $fd
  wapp-trim {
    <h1>Wapp Script That Shows A Copy Of Itself</h1>
    <pre>%html($script)</pre>
  }
  common-footer
}
proc wapp-page-style.css {} {
  wapp-mimetype text/css
  wapp-cache-control max-age=3600
  wapp-trim {
    pre {
       border: 1px solid black;
       padding: 1ex;
    }
  }
}
wapp-start $argv
