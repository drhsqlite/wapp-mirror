# Copyright (c) 2017 D. Richard Hipp
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the Simplified BSD License (also
# known as the "2-Clause License" or "FreeBSD License".)
#
# This program is distributed in the hope that it will be useful,
# but without any warranty; without even the implied warranty of
# merchantability or fitness for a particular purpose.
#
#---------------------------------------------------------------------------
#
# Design rules:
#
#   (1)  All identifiers in the global namespace begin with "wapp"
#
#   (2)  Indentifiers intended for internal use only begin with "wappInt"
#
#   (2)  Assume single-threaded operation
#
#   (3)  Designed for maintainability
#
proc wapp {txt} {
  global wapp
  append wapp(.reply) $txt
}
proc wapp-unsafe {txt} {
  global wapp
  append wapp(.reply) $txt
}
proc wapp-escape-html {txt} {
  global wapp
  append wapp(.reply) [string map {& &amp; < &lt; > &gt;} $txt]
}
proc wapp-reset {} {
  global wapp
  set wapp(.reply) {}
}
proc wapp-mimetype {x} {
  global wapp
  set wapp(.mimetype) $x
}
proc wapp-reply-code {x} {
  global wapp
  set wapp(.reply-code) $x
}

# This is a safety-check that is run prior to startup
#
# Examine the bodys of all procedures in this program looking for
# unsafe calls to "wapp".  Issue w
proc wapp-safety-check {} {
  foreach p [info procs] {
    set ln 0
    foreach x [split [info body $p] \n] {
      incr ln
      if {[regexp {[;\n] *wapp +\[} $x] ||
          [regexp {[;\n] *wapp +"[^\n]*[[$]} $x]} {
        puts "$p:$ln: unsafe \"wapp\" call: \"[string trim $x]\"\n"
      }
    }
  }
}

proc wapp-start {args} {
  set mode auto
  set port 0
  set n [llength $args]
  for {set i 0} {$i<$n} {incr i} {
    switch -- [lindex $args $i] {
      -port {incr i; set port [lindex $args $i]}
      -mode {incr i; set mode [lindex $args $i]}
      default {error "unknown option: [lindex $args 1]"}
    }
  }
  if {$mode=="auto" && [info exists env(GATEWAY_INTERFACE)]
        && $env(GATEWAY_INTERFACE)=="CGI/1.0"} {
     wappInt-cgi-request
  }
  if {$mode=="server"} {
    wappInt-start-listener $port 0 0
  } else {
    wappInt-start-listener $port 1 1
  }
}

# Start up a listening socket.  Arrange to invoke wappInt-new-connection
# for each inbound HTTP connection.
#
#    localonly   -   1 to listen on 127.0.0.1 only
#
#    browser     -   1 to launch a web browser pointing to the new server
#
proc wappInt-start-listener {port localonly browser} {
  if {$localonly} {
    set x [socket -server wappInt-new-connection -myaddr 127.0.0.1 $port]
  } else {
    set x [socket -server wappInt-new-connection $port]
  }
  if {$browser} {
    set port [chan configure $x -sockname]
    set url http://[lindex $port 1]:[lindex $port 2]/
    puts "exec firefox $url"
  }
}

# Accept a new inbound HTTP request
#
proc wappInt-new-connection {chan ip port} {
  global wappInt
  set wappInt($chan,REMOTE_HOST) $ip:$port
  set wappInt($chan,header) {}
  fconfigure $chan -blocking 0 -translation binary
  fileevent $chan readable "wappInt-readable $chan"
}

# Close an input channel
#
proc wappInt-close-channel {chan} {
  global wappInt
  foreach i [array names wappInt $chan,*] {unset wappInt($i)}
  close $chan
}

# Process new text received on an inbound HTTP request
#
proc wappInt-readable {chan} {
  if {[catch "$wappInt-readable-unsafe $chan"]} {
    wappInt-close-channel $chan
  }
}
proc wappInt-readable-unsafe {chan} {
  global wappInt
  set n [gets $chan line]
  if {$n>0} {
    if {[regexp {^\s+} $line]} {
      append wappInt($chan,header) $line
    } else {
      append wappInt($chan,header) \n$line
    }
    if {[string length $wappInt($chan,header)]>100000} {
      error "HTTP request header too big - possible DOS attack"
    }
  } elseif {$n==0} {
    wappInt-parse-header $chan
    if {$wappInt($chan,REQUEST_METHOD)=="POST"
           && [info exists wappInt($chan,CONTENT_LENGTH)]
           && [string is integer -strict $wappInt($chan,CONTENT_LENGTH)]} {
      set wappInt($chan,toread) $wappInt($chan,CONTENT_LENGTH)
      fileevent $chan readable [list wappInt-read-post-data $chan]
    } else {
      wappInt-handle-request $chan
    }
  }
}

# Read in as much of the POST data as we can
#
proc wappInt-read-post-data {chan} {
  global wappInt
  
}
