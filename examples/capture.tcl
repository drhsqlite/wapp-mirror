# This Wapp script records all inbound HTTP requests.  A description
# of each request is stored in -SCRIPT-log.txt where SCRIPT is the base
# name of this script.
#
package require wapp
proc wapp-default {} {
  wapp-allow-xorigin-params
  set msg "------------ New request ---------\n"
  foreach var [lsort [wapp-param-list]] {
    append msg "$var [list [wapp-param $var]]\n"
  }
  set dnam [wapp-param SCRIPT_FILENAME]
  set logfile [file dir $dnam]
  append logfile /-
  append logfile [file root [file tail $dnam]]-log.txt
  set out [open $logfile a]
  puts $out $msg
  close $out
  wapp-trim {<p>Ok</p>}
}
wapp-start $argv
