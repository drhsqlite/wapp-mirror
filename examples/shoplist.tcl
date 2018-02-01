#!/usr/bin/wapptclsh
#
# This script implements a simple shopping list.  To install:
#
#    (1) Create the database using:
#
#        CREATE TABLE shoplist(id INTEGER PRIMARY KEY AUTOINCREMENT,
#                              x TEXT UNIQUE COLLATE nocase);
#        CREATE TABLE done(delid INTEGER PRIMARY KEY AUTOINCREMENT,
#                          id INTEGER, x TEXT COLLATE nocase);
#        CREATE TABLE config(name TEXT PRIMARY KEY, value ANY) WITHOUT ROWID;
#        INSERT INTO config VALUES('password',<Your-Password-Here>);
#
#    (2) Edit this script to put the full pathname of the database as the
#        DBFILE variable
#
#    (3) Make this script a CGI on your server.  Or run it in some other
#        way that Wapp supports.
#
set DBFILE /shoppinglist.db  ;# Change to name of the database.

# Every page should call this routine first, and abort if this
# routine returns non-zero.
#
# This routine outputs the page header and opens the database file.
# It checks the login cookie.  If the user is not logged in, this routine
# paints the login screen and returns 1 (causing the caller page to abort).
# 
proc shopping-list-header {} {
  wapp-trim {
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link href="%url([wapp-param SCRIPT_NAME]/style.css)" rel="stylesheet">
    <title>Shopping List</title>
    </head><body>
    <h1>Shopping List</h1>
  }
  sqlite3 db $::DBFILE
  db timeout 1000
  db eval BEGIN
  if {[wapp-param-exists logout]} {
    wapp-clear-cookie shopping-list-login
    set pswd {}
  } else {
    set pswd [wapp-param pswd [wapp-param shopping-list-login]]
  }
  if {$pswd=="" 
    || ![db exists {SELECT 1 FROM config WHERE name='password' AND value=$pswd}]
  } {
    wapp-trim {
      <p><form method="POST" action="%url([wapp-param SELF_URL])">
      Password: <input type="password" name="pswd" width=12>
      <input type="submit" value="Login"></form></p>
    }
    db eval COMMIT
    db close
    return 1
  }
  if {[wapp-param-exists pswd]} {
    wapp-set-cookie shopping-list-login $pswd
  }
  return 0
}

# Every page should call this routine at the end to clean up the database
# connection.
#
proc shopping-list-footer {} {
  db eval COMMIT
  db close
}

# The default action is to show the current shopping list.
#
# Query parameters may cause changes to the shopping list:
#    del=ID       Delete shopping list item ID if it exists
#    add=NAME     Add a new shopping list item called NAME
#                 but only if there is no existing item with the
#                 same name
#    undel=ID     Undo a prior delete of item ID.
# Only one of the above edit operations may be applied per request.
# The edit action is applied prior to displaying the shopping list.
# All edit actions are idempotent.
#
proc wapp-default {} {
  if {[shopping-list-header]} return
  set base [wapp-param SCRIPT_NAME]
  if {[wapp-param-exists del]} {
    set id [expr {[wapp-param del]+0}]
    db eval {
       INSERT INTO done(id,x) SELECT id, x FROM shoplist WHERE id=$id;
       DELETE FROM shoplist WHERE id=$id;
    }
  } elseif {[wapp-param-exists add]} {
    set add [wapp-param add]
    db eval {INSERT OR IGNORE INTO shoplist(x) VALUES($add)}
  } elseif {[wapp-param-exists undel]} {
    set undelid [expr {[wapp-param undel]+0}]
    db eval {
      INSERT OR IGNORE INTO shoplist(id,x)
           SELECT id, x FROM done WHERE delid=$undelid;
      DELETE FROM done WHERE delid=$undelid;
    }
  }
  set cnt 0
  db eval {SELECT id, x FROM shoplist ORDER BY x} {
    # if {$cnt} {wapp-subst {<hr>\n}}
    incr cnt
    wapp-trim {
      <p>%html($x)
      <a class="button" href="%url($base/list?del=$id)">Got It!</a>
    }
  }
  if {$cnt} {wapp-subst {<hr>\n}}
  wapp-trim {
    <p><form method="GET" action="%url($base/list)">
    <input type="text" width="20" name="add">&nbsp;&nbsp;&nbsp;
    <input class="button" type="submit" value="Add"></form>
    <p><a class="button" href="%url($base/common)">Common Purchases</a>
  }
  db eval {SELECT delid FROM done ORDER BY delid DESC limit 1} {
    wapp-trim {
      <p><a class="button" href="%url($base/list?undel=$delid)">Undelete</a>
    }
  }
  wapp-trim {
    <p><a class="button" href="%url($base/list)">Refresh</a>
    <p><a class="button" href="%url($base/list?logout=1)">Logout</a>
  }
  shopping-list-footer
}

# This page shows recent purchases with an opportunity to re-add those
# purchases to the shopping list.  The idea is that to have easy access
# to common purchases.
#
proc wapp-page-common {} {
  if {[shopping-list-header]} return
  set base [wapp-param SCRIPT_NAME]
  wapp-subst {<p><a class="button" href="%url($base/list)">Go Back</a>}
  db eval {SELECT x FROM
             (SELECT DISTINCT x FROM done ORDER BY delid DESC LIMIT 30)
           ORDER BY x} {
    wapp-trim {
      <p>%html($x)
      <a class="button" href="%url($base/list?add=)%qp($x)">Add</a><br>
    }
  }
  shopping-list-footer
}

# The /env page shows the CGI environment.  This is for testing only.
# There are no links to this page.
#
proc wapp-page-env {} {
  if {[shopping-list-header]} return
  wapp-trim {
    <html>
    <h1>CGI Environment</h1>
    <pre>%html([wapp-debug-env])</pre>
  }
  shopping-list-footer
}

# The style-sheet
#
proc wapp-page-style.css {} {
  wapp-mimetype text/css
  wapp-cache-control max-age=3600
  wapp-trim {
     .button {
      font-size: 80%;
      text-decoration: none;
      padding: 2px 6px 2px 6px;
      border: 1px solid black;
      border-radius: 8px;
      background-color: #ddd;
    }
  }
}

# After all pages handling routines have been defined, start up
# the Wapp handler.
#
wapp-start $argv
