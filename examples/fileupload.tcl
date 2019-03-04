#!/usr/bin/wapptclsh
#
# This script demonstrates a Wapp application that can accept a file
# upload using <input type="file">
#
package require wapp
proc common-header {} {
  wapp-trim {
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link href="%url([wapp-param SCRIPT_NAME]/style.css)" rel="stylesheet">
    <title>Wapp File-Upload Demo</title>
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
proc wapp-default {} {
  wapp-cache-control max-age=3600
  common-header
  wapp-trim {
    <h1>Wapp File-Upload Demo</h1>
  }
  # NB:  You must set enctype="multipart/form-data" on your <form> in order
  # for file upload to work.
  wapp-trim {
    <p><form method="POST" enctype="multipart/form-data">
    File To Upload: <input type="file" name="file"><br>
    <input type="checkbox" name="showenv" value="1">Show CGI Environment<br>
    <input type="submit" value="Submit">
    </form></p>
  }
  # Ordinary query parameters come through just like normal
  if {[wapp-param showenv 0]} {
    wapp-trim {
      <h1>Wapp Environment</h1>
      <pre>%html([wapp-debug-env])</pre>
    }
  }
  # File upload query parameters come in three parts:  The *.mimetype,
  # the *.filename, and the *.content.
  set mimetype [wapp-param file.mimetype {}]
  set filename [wapp-param file.filename {}]
  set content [wapp-param file.content {}]
  if {$filename!=""} {
    wapp-trim {
      <h1>Uploaded File Content</h1>
      <p>Filename: %html($filename)<br>
      MIME-Type: %html($mimetype)<br>
      Content:</p>
      <blockquote><pre>
      %html($content)
      </pre></blockquote>
    }
  }
  common-footer
}
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
wapp-start $argv
