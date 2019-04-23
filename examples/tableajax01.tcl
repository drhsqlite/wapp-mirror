#!/usr/bin/wapptclsh
# This script demonstrates how to receive bulk HTML content
# (such as a complete <table>) and insert it in the middle
# of the DOM using XMLHttpRequest
#
package require wapp
proc common-header {} {
  wapp-trim {
    <html>
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link href="%url([wapp-param SCRIPT_NAME]/style.css)" rel="stylesheet">
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
  common-header
  wapp-trim {
    <p>This application demonstrates how to use XMLHttpResult to obtain
    bulk HTML text (such as a large &lt;table&gt;) and then insert that
    text in the middle of the DOM.</p>

    <div id="insertionPoint"></div>

    <p><form id="theForm">
    Click the button 
    <input type="submit" id="theButton" value="Click Here">
    to cause content to be inserted above this paragraph and below
    the initial paragraph
    </form></p>
    <script src='%url([wapp-param SCRIPT_NAME]/script.js)'></script>

    <p><a href='%html([wapp-param SCRIPT_NAME])/self'>Show the Wapp script
    that generates this page</a></p>
  }
  common-footer
}

# This is the javascript that takes control of the form and causes form
# submissions to fetch and insert HTML text.
#
proc wapp-page-script.js {} {
  wapp-mimetype text/javascript
  wapp-cache-control max-age=3600
  wapp-trim {
    document.getElementById("theForm").onsubmit = function(){
      var xhttp = new XMLHttpRequest();
      xhttp.open("GET", "%string([wapp-param BASE_URL])/gettable", true);
      xhttp.onreadystatechange = function(){
        if(this.readyState!=4)return
        document.getElementById("insertionPoint").innerHTML = this.responseText;
        document.getElementById("insCancel").onclick = function(){
          document.getElementById("insertionPoint").innerHTML = null
        }
      }
      xhttp.send();
      return false
    }
  }
}

# This counter increments on each /gettable call.
set counter 0

# The /gettable page returns the content of a table to be inserted
# in the original page.
#
proc wapp-page-gettable {} {
  global counter
  incr counter
  wapp-trim {
    <table border="1">
    <tr><th>Column 1<th>Column 2<th>Column 3
    <tr><td>1.1<td>1.2<td>1.3
    <tr><td>2.1<td>2.2<td>2.3
    <tr><td>%html($counter)<td><td><button id="insCancel">Cancel</button>
    </table>
  }
}

# The /self page that shows the text of this script.
#
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
