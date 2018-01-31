#!/usr/bin/wapptclsh
#
# This script implements a simple shopping list.  To install:
#
#    (1) Create the database using:
#
#        CREATE TABLE shoplist(id INTEGER PRIMARY KEY AUTOINCREMENT, x TEXT);
#        CREATE TABLE done(delid INTEGER PRIMARY KEY AUTOINCREMENT,
#                          id INTEGER, x TEXT);
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
  wapp-trim {
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Shopping List</title>
    </head><body>
    <h1>Shopping List</h1>
  }
  set self [wapp-param SELF_URL]
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
      <p><form method="POST" action="%url($self)">
      Password: <input type="password" name="pswd" width=12>
      <input type="submit" value="Login"></form></p>
    }
    db eval COMMIT
    db close
    return
  }
  if {[wapp-param-exists pswd]} {
    wapp-set-cookie shopping-list-login $pswd
  }
  if {[wapp-param-exists del]} {
    set id [expr {[wapp-param del]+0}]
    db eval {
       INSERT INTO done(id,x) SELECT id, x FROM shoplist WHERE id=$id;
       DELETE FROM shoplist WHERE id=$id;
    }
  } elseif {[wapp-param-exists add]} {
    set add [wapp-param add]
    db eval {INSERT INTO shoplist(x) VALUES($add)}
  } elseif {[wapp-param-exists undel]} {
    set mx [db one {SELECT max(delid) FROM done}]
    db eval {
      INSERT INTO shoplist(id,x) SELECT id, x FROM done WHERE delid=$mx;
      DELETE FROM done WHERE delid=$mx;
    }
  }
  set cnt 0
  db eval {SELECT id, x FROM shoplist ORDER BY id} {
    if {$cnt} {wapp-subst {<hr>\n}}
    incr cnt
    wapp-trim {
      <p><form method="POST" action="%url($self)">
      %html($x)
      <input type="hidden" name="del" value="%html($id)">
      <input type="submit" value="Got It!"></form>
    }
  }
  if {$cnt} {wapp-subst {<hr>\n}}
  wapp-trim {
    <p><form method="POST" action="%url($self)">
    <input type="text" name="add" width="25">
    <input type="submit" value="Add"></form>
    <hr>
    <p><form method="POST" action="%url($self)">
    <input type="submit" name="undel" value="Undelete">
    <input type="submit" name="logout" value="Logout"></form>
  }
  db eval COMMIT
  db close
}
wapp-start $argv
