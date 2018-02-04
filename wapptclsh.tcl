# This script runs to initialize wapptclsh.
#
proc initialize_wapptclsh {} {
  global argv argv0 main_script
  if {[llength $argv]==0} return
  set script [lindex $argv 0]
  if {[file readable $script]} {
    set fd [open $script r]
    set main_script [read $fd]
    close $fd
    set argv [lrange $argv 1 end]
    set argv0 $script
  }
}
initialize_wapptclsh
