#!/usr/bin/wapptclsh
#
# Show all files in the same directory as the script.
#
package require wapp
proc wapp-page-env {} {
  wapp-allow-xorigin-params
  wapp-trim {
    <h1>Wapp Environment</h1>
    <pre>%html([wapp-debug-env])</pre>
  }
}
proc wapp-default {} {
  cd [file dir [wapp-param SCRIPT_FILENAME {}]]
  regsub {/[^/]+$} [wapp-param BASE_URL] {} base
  wapp-trim {
     <html>
     <body>
     <ol>
  }
  foreach file [lsort [glob -nocomplain *]] {
    if {[file isdir $file]} continue
    if {![file readable $file]} continue
    wapp-trim {
       <li><a href="%html($base/$file)">%html($file)</a></li>
    }
  }
  wapp-trim {</ol>\n}
}
wapp-start $argv
