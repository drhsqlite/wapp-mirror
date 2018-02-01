#!/usr/bin/tclsh
#
# Convert a binary file (such as an image) into hex.
#
# Usage:
#
#     tclsh file-to-hex.tcl FILENAME
#
if {[llength $argv]!=2} {
  puts stderr "Usage: $argv0 (hex|base64) FILENAME"
  exit 1
}
set mode [lindex $argv 0]
if {$mode!="hex" && $mode!="base64"} {
  puts stderr "Usage: $argv0 (hex|base64) FILENAME"
  exit
}
set filename [lindex $argv 1]
set fd [open $filename rb]
set x [binary encode $mode [read $fd]]
puts "  wapp-unsafe \[binary decode $mode \173"
set n [string length $x]
for {set i 0} {$i<$n} {incr i 64} {
  puts "    [string range $x $i [expr {$i+63}]]"
}
puts "  \175\]"
