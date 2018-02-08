# This script demonstrates a Wapp application that can display a copy
# of itself using a font color selected by a query parameter.
#
# The foreground color is whatever value is given by the color= query
# parameter.  The color is inserted into a style= attribute on the
# <pre> element using the %url(...) substitution mechanism of Wapp,
# so it is safe from XSS injections.  Try it!  You won't be able to
# slip in any unwanted HTML, but you can use %23 to get a # for
# an RGB color, like this:
#
#              ?color=%23003f7f
#
package require wapp
proc wapp-default {} {
  wapp-content-security-policy {default_src 'self' 'inline'}
  wapp-allow-xorigin-params
  set fd [open [wapp-param SCRIPT_FILENAME] rb]
  set script [read $fd]
  close $fd
  set self [wapp-param SELF_URL]
  wapp-trim {
    <html>
    <head>
    <link href="%url([wapp-param SCRIPT_NAME]/style.css)" rel="stylesheet">
    <title>Wapp Self-Display Demo</title>
    </head>
    <body>
    <p>In the box below is shown the Wapp script that generated this page.
    Change the foreground color using the color= query parameter.
    Examples:</p>
    <ul>
    <li><a href='%url($self?color=red)'>%html($self?color=red)</a>
    <li><a href='%url($self?color=green)'>%html($self?color=green)</a>
    <li><a href='%url($self?color=blue)'>%html($self?color=blue)</a>
    <li><a href='%url($self)?color=%23003f7f'>%html($self?color=%23003f7f)</a>
    </ul>
    </p>
    <pre style='color: %url([wapp-param color black]);'>%html($script)</pre>
  }
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
