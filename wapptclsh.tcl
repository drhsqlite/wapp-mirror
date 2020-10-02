# This script runs to initialize wapptclsh.
#
proc initialize_wapptclsh {} {
  global argv argv0 main_script
  if {[llength $argv]==0} {
    set script --help
  } else {
    set script [lindex $argv 0]
  }
  if {[string index $script 0]=="-"} {
    set opt [string trim $script -]
    if {$opt=="v"} {
      puts stderr "Wapp using SQLite version [sqlite3 -version]"
    } else {
      puts stderr "Usage: $argv0 FILENAME"
      puts stderr "Options:"
      puts stderr "   -v      Show version information"
    }
    exit 1
  } elseif {[file readable $script]} {
    set fd [open $script r]
    set main_script [read $fd]
    close $fd
    set argv [lrange $argv 1 end]
    set argv0 $script
  } else {
    puts stderr "unknown option: \"$script\"\nthe --help option is available"
  }
}
initialize_wapptclsh
