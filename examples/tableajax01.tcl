# This script demonstrates how to receive bulk HTML content
# (such as a complete <table>) and inserting it in the middle
# of the DOM using XMLHttpRequest
#
package require wapp
proc wapp-default {} {
  wapp-trim {
    <html>
    <body>
    <p>This application demonstrations how to use XMLHttpResult to obtain
    bulk HTML text (such as a large &lt;table&gt;) and then insert that
    text in the middle of the DOM.</p>

    <div id="insertionPoint"></div>

    <p><form id="theForm">
    Click the button 
    <input type="submit" id="theButton" value="Click Here">
    to cause content to be inserted above this paragraph and below
    the initial paragraph
    </form></p>
    <script>
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
    </script>
  }
}
set counter 0
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
wapp-start $argv
