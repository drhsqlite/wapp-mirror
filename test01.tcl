# Invoke as "tclsh test01.tcl" and then surf the website that pops up
# to verify the logic in wapp.
#
source wapp.tcl
proc wapp-default {} {
  global wapp
  set B [wapp-param BASE_URL]
  set R [wapp-param SCRIPT_NAME]
  wapp-cache-control max-age=15
  wapp "<h1>Hello, World!</h1>\n"
  wapp "<ol>"
  wapp-unsafe "<li><p><a href='$R/env'>Wapp Environment</a></p>\n"
  wapp-subst {<li><p><a href='env2'>Environment using wapp-debug-env</a>\n}
   wapp-subst {<li><p><a href='%html($B)/fullenv'>Full Environment</a>\n}
  set crazy [lsort [dict keys $wapp]]
  wapp-subst {<li><p><a href='%html($B)/env?keys=%url($crazy)'>}
  wapp "Environment with crazy URL</a>\n"
  wapp-trim {
    <li><p><a href='%html($B)/lint'>Lint</a>
    <li><p><a href='%html($B)/errorout'>Deliberate error</a>
    <li><p><a href='%html($B)/encodings'>Encoding checks</a>
    <li><p><a href='%html($B)/redirect'>Redirect to env</a>
    <li><p><a href='globals'>TCL global variables</a>
  }
  set x "%string(...)"
  set v abc'def\"ghi\\jkl
  wapp-subst {<li>%html($x) substitution test: "%string($v)"\n}
  wapp "</ol>"
  if {[dict exists $wapp showenv]} {
    wapp-page-env
  }
}
proc wapp-page-redirect {} {
  wapp-redirect env
}
proc wapp-page-globals {} {
  wapp-trim {
    <h1>TCL Global Variables</h1>
    <ul>
  }
  foreach vname [lsort [uplevel #0 info vars]] {
    set val ???
    catch {set val [set ::$vname]}
    wapp-subst {<li>%html($vname = [list $val])</li>\n}
  }
}
proc wapp-page-env2 {} {
  wapp-allow-xorigin-params
  wapp-trim {
    <h1>Wapp Environment using wapp-debug-env</h1>
    <p>This page uses wapp-allow-xorigin-params so that new
       query parameters may be added manually to the URL.</p>
    <pre>%html([wapp-debug-env])</pre>
  }
}
proc wapp-page-env {} {
  global wapp
  wapp-set-cookie env-cookie simple
  wapp "<h1>Wapp Environment</h1>\n"
  wapp-unsafe "<form method='GET' action='[wapp-param SELF_URL]'>\n"
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
  wapp-unsafe "<p><a href='[wapp-param BASE_URL]/'>Home</a></p>\n"
}
proc wapp-page-fullenv {} {
  global wapp
  wapp-set-cookie env-cookie full
  wapp "<h1>Wapp Full Environment</h1>\n"
  wapp-unsafe "<form method='POST' action='[wapp-param SELF_URL]'>\n"
  wapp "<input type='checkbox' name='var1'"
  if {[dict exists $wapp showhdr]} {
    wapp " checked"
  }
  wapp "> Var1\n"
  wapp "<input type='submit' name='s1' value='Go'>\n"
  wapp "<input type='hidden' name='hidden-parameter-1' "
  wapp "value='the long value / of ?$ hidden-1..<hi>'>\n"
  wapp "</form>"
  wapp "<pre>\n"
  foreach var [lsort [dict keys $wapp]] {
    if {$var==".reply"} continue
    wapp-escape-html "$var = [list [dict get $wapp $var]]\n\n"
  }
  wapp "</pre>"
  wapp-subst {<p><a href='%html([dict get $wapp BASE_URL])/'>Home</a></p>\n}
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
proc wapp-page-encodings {} {
  set strlist {
     {Johann Strauß}
     {Вагиф Сәмәдоғлу}
     {中国}
     {$[hi]{there}$}
     {https://drh@sqlite.org/info?name=trunk#block2}
  }
  wapp-subst {
     <h1>Test the %qp substitutions</h1>
     <table border=1 cellpadding=5>
     <tr><th>Original<th>Encoded<th>Round-Trip</tr>
  }
  foreach str $strlist {
    wapp-subst {<tr><td>%unsafe($str)<td>%qp($str)}
    set x [wappInt-decode-url [wappInt-enc-qp $str]]
    wapp-subst {<td>%unsafe($x)</tr>\n}
  }
  wapp-subst {</table>}

  wapp-subst {
     <h1>Test the %url substitutions</h1>
     <table border=1 cellpadding=5>
     <tr><th>Original<th>Encoded<th>Round-Trip</tr>
  }
  foreach str $strlist {
    wapp-subst {<tr><td>%unsafe($str)<td>%url($str)}
    set x [wappInt-decode-url [wappInt-enc-url $str]]
    wapp-subst {<td>%unsafe($x)</tr>\n}
  }
  wapp-subst {</table>}
}
# Deliberately generate an error to test error handling.
proc wapp-page-errorout {} {
  wapp "<h1>Intentially generate an error</h1>\n"
  wapp "<p>This test should be ignored by the error handler\n"
  wapp $noSuchVariable
  wapp "<p>After the error\n"
}
wapp-start $::argv
