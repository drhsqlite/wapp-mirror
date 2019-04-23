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
  wapp-content-security-policy {default-src 'self'; img-src 'self' data:}
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
    <p><a href='%html([wapp-param SCRIPT_NAME])/self'>Show the script
    that generates this page</a></p>
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
    }
    if {[string match image/* $mimetype]} {
      # If the mimetype is an image, display the image using an
      # in-line <img> mark.  Note that the content-security-policy
      # must be changed to allow "data:" for type img-src in order
      # for this to work.
      set b64 [binary encode base64 $content]
      wapp-trim {
        Content:</p>
        <blockquote>
        <img src='data:%html($mimetype);base64,%html($b64)'>
        </blockquote>
      }
    } else {
      # Anything other than image, just show it as text.
      wapp-trim {
        Content:</p>
        <blockquote><pre>
        %html($content)
        </pre></blockquote>
      }
    }
  }
  common-footer
}
proc wapp-page-self {} {
  wapp-cache-control max-age=3600
  common-header
  set fd [open [wapp-param SCRIPT_FILENAME] rb]
  set script [read $fd]
  close $fd
  wapp-trim {
    <h1>Wapp Script That Shows A Copy Of Itself</h1>
    <pre>%html($script)</pre>
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
