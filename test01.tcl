# Invoke as "tclsh test01.tcl" and then surf the website that pops up
# to verify the logic in wapp.
#
source wapp.tcl
proc wapp-default {} {
  global wapp
  wapp "<h1>Hello, World!</h1>\n"
  wapp-unsafe "<p>See the <a href='[dict get $wapp BASE_URL]/env'>Wapp "
  wapp "Environment</a></p>"
}
proc wapp-page-env {} {
  global wapp
  wapp "<h1>Wapp Environment</h1>\n"
  wapp "<pre>\n"
  foreach var [lsort [dict keys $wapp]] {
    if {[string index $var 0]=="." && $var!=".header"} continue
    wapp-escape-html "$var = [list [dict get $wapp $var]]\n"
  }
  wapp "</pre>"
}
wapp-start $::argv
