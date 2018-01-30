# This script is a template used for testing.
#
# After making modifications to this script to test out bits of HTML
# (or not - the script works fine as it is), invoke the script using
#
#   wapptclsh env.tcl
#
# All web pages show the Wapp execution environment, which includes
# CGI-line environment variables, decoded query and POST parameters, and 
# decoded cookies.
#
package require wapp
proc wapp-default {} {
  wapp-trim {
    <h1>Wapp Environment</h1>
    <pre>%html([wapp-debug-env])</pre>
  }
}
wapp-start $argv
