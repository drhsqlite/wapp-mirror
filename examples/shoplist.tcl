#!/usr/bin/wapptclsh
#
# This script implements a simple shopping list.  To install:
#
#    (1) Create the database using:
#
#        CREATE TABLE shoplist(id INTEGER PRIMARY KEY AUTOINCREMENT,
#                              x TEXT UNIQUE COLLAGE nocase);
#        CREATE TABLE done(delid INTEGER PRIMARY KEY AUTOINCREMENT,
#                          id INTEGER, x TEXT COLLAGE nocase);
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
proc wapp-default {} {
  if {[shopping-list-header]} return
  set base [wapp-param BASE_URL]
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
    <p><form method="GET" action="$base/list">
    <input type="text" width="20" name="add">
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
proc shopping-list-header {} {
  set base [wapp-param BASE_URL]
  wapp-trim {
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link href="%url($base/style.css)" rel="stylesheet">
    <title>Shopping List</title>
    </head><body>
    <h1>Shopping List</h1>
  }
  sqlite3 db $::DBFILE
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
proc shopping-list-footer {} {
  db eval COMMIT
  db close
}
proc wapp-page-common {} {
  if {[shopping-list-header]} return
  set base [wapp-param BASE_URL]
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
proc wapp-page-style.css {} {
  wapp-mimetype text/css
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
wapp-start $argv
