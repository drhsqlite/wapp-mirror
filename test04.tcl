source wapp.tcl
    package require wapp
    proc wapp-default {} {
      global wapp
      wapp "<h1>Hello, World!</h1>\n"
      set B [dict get $wapp BASE_URL]
      wapp-subst {<p>See the <a href='%html($B)/env'>Wapp }
      wapp "Environment</a></p>"
    }
    proc wapp-page-env {} {
      global wapp
      wapp "<h1>Wapp Environment</h1>\n"
      wapp "<pre>\n"
      foreach var [lsort [dict keys $wapp]] {
        if {[string index $var 0]=="."} continue
        wapp-subst {%html($var) = %html([list [dict get $wapp $var]])\n}
      }
      wapp "</pre>"
    }
    wapp-start $::argv
