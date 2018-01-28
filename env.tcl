# This script is a template used for testing.
#
# After making modifications to this script to test out bits of HTML
# (or not - the script works fine as it is), invoke the script using
#
#   wapptclsh env.tcl
#
# All web pages show the CGI environment.
#
package require wapp
proc wapp-default {} {
  global wapp
  wapp-trim {
    <h1>Wapp Environment</h1>
    <pre>
  }
  foreach var [lsort [dict keys $wapp]] {
    if {[string index $var 0]=="."} continue
    wapp-subst {%html($var) = %html([list [dict get $wapp $var]])\n}
  }
  wapp-subst {</pre>\n}
}
wapp-start $argv
