# Invoke as "tclsh test05.tcl" and then surf the website that pops up
# to verify the logic in wapp.
#
# This script demonstrates how to use a wapp-before-dispatch-hook to
# rewrite some of the environment variables such that the URL begins with
# an object name and the method follows the object name.
#
source wapp.tcl
proc wapp-default {} {
  global wapp
  wapp-set-cookie env-cookie simple
  wapp-subst {<h1>Wapp Environment</h1>\n}
  wapp-subst {<form method='GET' action='%html([dict get $wapp SELF_URL])'>\n}
  wapp-subst {<input type='checkbox' name='showhdr'}
  if {[dict exists $wapp showhdr]} {
    wapp-subst { checked}
  }
  wapp-subst {> Show Header\n}
  wapp-subst {<input type='submit' value='Go'>\n}
  wapp-subst {</form>}
  wapp-subst {<pre>\n}
  foreach var [lsort [dict keys $wapp]] {
    if {[string index $var 0]=="." &&
         ($var!=".header" || ![dict exists $wapp showhdr])} continue
    wapp-escape-html "$var = [list [dict get $wapp $var]]\n"
  }
  wapp {</pre>}
  wapp-subst {<p><a href='%html([dict get $wapp BASE_URL])/x001/method1/arg'>}
  wapp-subst {The "method1" method on object "x001"</a></p>\n}
}
proc wapp-page-method1 {} {
  global wapp
  wapp-subst {<h1>The xyzzy page for }
  wapp-subst {object "%html([dict get $wapp OBJECT])"</h1>\n}
  wapp-subst {<pre>\n}
  foreach var [lsort [dict keys $wapp]] {
    if {[string index $var 0]=="."} continue
    wapp-escape-html "$var = [list [dict get $wapp $var]]\n"
  }
  wapp-subst {</pre>\n}
}
proc wapp-before-dispatch-hook {} {
  global wapp
  set objname [dict get $wapp PATH_HEAD]
  # always set ROOT_URL to the original BASE_URL
  dict set wapp ROOT_URL [dict get $wapp BASE_URL]
  # If the first term of REQUEST_URI is a valid object name, make it
  # the OBJECT and shift a new PATH_HEAD out of PATH_TAIL.
  if {![regexp {^x\d+$} $objname]} {
    dict set wapp OBJECT {}
    return
  }
  if {$objname=="x000"} {error "unauthorized object"}
  dict set wapp OBJECT $objname
  dict set wapp OBJECT_URL [dict get $wapp BASE_URL]/$objname
  if {[regexp {^([^/]+)(.*)$} [dict get $wapp PATH_TAIL] all head tail]} {
    dict set wapp PATH_HEAD $head
    dict set wapp PATH_TAIL [string trimleft $tail /]
  } else {
    dict set wapp PATH_HEAD {}
    dict set wapp PATH_TAIL {}
  }
}
wapp-start $::argv
