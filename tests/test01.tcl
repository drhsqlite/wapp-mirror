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
    <li><p><a href='csptest'>Content Security Policy</a>
  }
  set x "%string(...)"
  set v abc'def\"ghi\\jkl
  wapp-subst {<li>%html($x) substitution test: "%string($v)"\n}
  wapp "</ol>"
  if {[dict exists $wapp showenv]} {
    wapp-page-env
  }
  wapp-trim {
    <p>The creator of Wapp:<br>
    <img src="%url($R/drh.jpg)">
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
  # Deliberately unsafe calls to wapp-subst and wapp-trim, added here
  # to test wapp-safety-check
  #
  wapp-subst "> Var1\n"
  wapp-trim "<input type='submit' name='s1' value='Go'>\n"
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
  # The following line deliberately throws an error to test the
  # error recovering logic within Wapp
  wapp $noSuchVariable
  wapp "This is a $test of wapp-safety-check"
  wapp "This is another [test of] wapp-safety-check"
  wapp "<p>After the error\n"
}
proc wapp-page-csptest {} {
  wapp-allow-xorigin-params
  if {[wapp-param-exists csp]} {
    wapp-content-security-policy [wapp-param csp]
  }
  wapp-trim {
    <h1>Content Security Policy Test Page</h1>
    <p> There is a &lt;script&gt; at the bottom of
    this page that will invoke an alert().  The
    script will be disabled by the default CSP.
    <p>Use the csp= query parameter to change CSP.
    <script>alert("This is the alert");</script>
  }
}
proc wapp-page-drh.jpg {} {
  wapp-mimetype image/jpeg
  wapp-cache-control max-age=3600
  wapp-unsafe [binary decode base64 {
    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
    UFRfOaiJ1qgxzqqc0BS+Vqirll/sw+ZqtmPT/9k=
  }]
}
wapp-start $::argv
