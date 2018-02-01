# This script demonstrates how to send form data from the client browser
# back up to the server using an XMLHttpRequest with JSON content.
#
package require wapp

# The default page paints a form to be submitted.
# The default content-security-policy of Wapp restricts the use
# of in-line javascript, so the script content must be returned by
# a separate resource.
#
proc wapp-default {} {
  wapp-trim {
    <h1>Example Of Sending Form Data As JSON Using AJAX</h1>
    <form id="nameForm">
    <table border="0">
    <tr><td align="right"><label for="firstName">First name:</label>&nbsp;</td>
        <td><input type="text" id="firstName" width="20">
    <tr><td align="right"><label for="lastName">Last name:</label>&nbsp;</td>
        <td><input type="text" id="lastName" width="20">
    <tr><td align="right"><label for="age">Age:</label>&nbsp;</td>
        <td><input type="text" id="age" width="6">
    <tr><td><td><input type="submit" value="Send">
    </table>
    </form>
    <script src='%url([wapp-param SCRIPT_NAME]/script.js)'></script>
  }
}

# This is the javascript that takes control of the form and causes form
# submissions to be send using XMLHttpRequest with JSON content
#
proc wapp-page-script.js {} {
  wapp-mimetype text/javascript
  wapp-cache-control max-age=3600
  wapp-trim {
    document.getElementById("nameForm").onsubmit = function(){
      function val(id){ return document.getElementById(id).value }
      var jx = {
         "firstname":val("firstName"),
         "lastname": val("lastName"),
         "age": val("age")
      }
      var xhttp = new XMLHttpRequest();
      xhttp.open("POST", "%string([wapp-param SCRIPT_NAME])/acceptjson", true);
      xhttp.setRequestHeader("Content-Type","text/json");
      xhttp.send(JSON.stringify(jx));
      return false
    }
  }
}

# This page accepts a form submission and prints it on standard output.
# A real server would do something useful with the data.
#
proc wapp-page-acceptjson {} {
  puts "Accept Json Called"
  puts "mimetype: [list [wapp-param CONTENT_TYPE]]"
  puts "content: [list [wapp-param CONTENT]]"
}
wapp-start $argv
