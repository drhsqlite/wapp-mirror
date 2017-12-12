# Invoke as "tclsh test01.tcl" and then surf the website that pops up
# to verify the logic in wapp.
#
source wapp.tcl
proc wapp-default {} {
  global wapp
  wapp "<h1>Hello, World!</h1>\n"
  wapp "<p>See the <a href='/env'>Wapp Environment</a></p>\n"
  wapp "<p>Another link: "
  wapp-unsafe "<a href='[dict get $wapp BASE_URL]/fullenv'>"
  wapp "Full Environment</a>\n"
  wapp "<p>Lint this application: "
  wapp-unsafe "<a href='[dict get $wapp BASE_URL]/lint'>"
  wapp "Lint</a>\n"
}
proc wapp-page-env {} {
  global wapp
  wapp-set-cookie env-cookie simple
  wapp "<h1>Wapp Environment</h1>\n"
  wapp-unsafe "<form method='GET' action='[dict get $wapp SELF_URL]'>\n"
  wapp "<input type='checkbox' name='showhdr'"
  if {[dict exists $wapp showhdr]} {
    wapp " checked"
  }
  wapp "> Show Header\n"
  wapp "<input type='submit' value='Go'>\n"
  wapp "</form>"
  wapp "<pre>\n"
  foreach var [lsort [dict keys $wapp]] {
    if {[string index $var 0]=="." &&
         ($var!=".header" || ![dict exists $wapp showhdr])} continue
    wapp-escape-html "$var = [list [dict get $wapp $var]]\n"
  }
  wapp "</pre>"
  wapp-unsafe "<p><a href='[dict get $wapp BASE_URL]/'>Home</a></p>\n"
}
proc wapp-page-fullenv {} {
  global wapp
  wapp-set-cookie env-cookie full
  wapp "<h1>Wapp Full Environment</h1>\n"
  wapp-unsafe "<form method='POST' action='[dict get $wapp SELF_URL]'>\n"
  wapp "<input type='checkbox' name='var1'"
  if {[dict exists $wapp showhdr]} {
    wapp " checked"
  }
  wapp "> Var1\n"
  wapp "<input type='submit' value='Go'>\n"
  wapp "</form>"
  wapp "<pre>\n"
  foreach var [lsort [dict keys $wapp]] {
    if {$var==".reply"} continue
    wapp-escape-html "$var = [list [dict get $wapp $var]]\n\n"
  }
  wapp "</pre>"
  wapp-unsafe "<p><a href='[dict get $wapp BASE_URL]/'>Home</a></p>\n"
}
proc wapp-page-lint {} {
  wapp "<h1>Potental Cross-Site Injection Vulerabilities In This App</h1>\n"
  set res [wapp-safety-check]
  if {$res==""} {
    wapp "<p>No problems found.</p>\n"
  } else {
    wapp "<pre>\n"
    wapp-escape-html $res
    wapp "</pre>\n"
  }
}
wapp-start $::argv
