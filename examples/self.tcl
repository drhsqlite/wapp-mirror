#!/usr/bin/wapptclsh
#
# This script demonstrates a Wapp application that can display a copy
# of itself via the /self page.  (See the wapp-page-self procedure for
# how that one page is generated.)
#
# This script also has a homepage and an /env page that show the wapp
# environment.  The header and footer for each page is broken out into
# separate subroutines.
#
# Just for grins, there is also a style-sheet and some cache-control
# lines to show how those things work.
#
package require wapp
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
    <ul>
    <li> <a href='%url([wapp-param SCRIPT_NAME])/self'>Show the script
    that generates this page</a>
    <li> <a href='%url([wapp-param SCRIPT_NAME])/env'>Wapp Environment</a>
    </ul>
  }
  common-footer
}
proc wapp-page-env {} {
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
