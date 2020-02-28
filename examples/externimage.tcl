#!/usr/bin/wapptclsh
#
# This script demonstrates how Wapp to return resources (such as
# an image) held in separate files or in a separate SQLite database.
#
package require wapp

# Common header and footer.
proc common-header {} {
  wapp-trim {
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link href="%url([wapp-param SCRIPT_NAME]/style.css)" rel="stylesheet">
    <title>Wapp External Content Demo</title>
    </head>
    <body>
  }
}
proc common-footer {} {
  wapp-trim {
    </body>
    </html>
  }
}

# The style sheet
proc wapp-page-style.css {} {
  wapp-mimetype text/css
  wapp-cache-control max-age=3600
  wapp-trim {
    pre {
       border: 1px solid black;
       padding: 1ex;
    }
  }
}

# This is the default page
proc wapp-default {} {
  common-header
  wapp-trim {
    <h1>External Content Demo</h1>
    <p>This demo shows how Wapp can return resources (such as images)
    that are loaded from separate files on disk, or from a separate
    database.  This demo shows two images:

    <p><img src="image1"><br>"plume1"
    <p><img src="image2"><br>"plume2"

    <p>Both images are the same PNG file.  The first image is loaded
    from a separate file on disk.  The second image is loaded form
    an SQLite database.

    <p>Click <a href="self">here</a> to see the complete Wapp script
    that generates this application.
  }
}

# The /self page that returns HTML that displays a copy of this script itself
proc wapp-page-self {} {
  wapp-cache-control max-age=3600
  common-header
  set fd [open [wapp-param SCRIPT_FILENAME] rb]
  set script [read $fd]
  close $fd
  wapp-trim {
    <h1>Text Of The External Content Demo Script</h1>
    <pre>%html($script)</pre>
  }
  common-footer
}

# The /image1 image, read from a separate file named "plume.png"
# found in the same directory as this script.
#
proc wapp-page-image1 {} {
  wapp-mimetype image/png
  set filename [file dir [wapp-param SCRIPT_FILENAME]]/plume.png
  set fd [open $filename rb]
  wapp [read $fd]
  close $fd
}

# The /image2 image, read from an SQLite database named "plume.db"
# found in the same directory as this script.
#
proc wapp-page-image2 {} {
  set dbname [file dir [wapp-param SCRIPT_FILENAME]]/plume.db
  sqlite3 db $dbname
  db eval {SELECT data, mimetype FROM image LIMIT 1} break
  wapp-mimetype $mimetype
  wapp $data
  db close
}

# Start Wapp running
wapp-start $argv
