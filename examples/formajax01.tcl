# This script demonstrates how to send form data from the client browser
# back up to the server using an XMLHttpRequest with JSON content.
#
package require wapp
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
    <script>
    document.getElementById("nameForm").onsubmit = function(){
      function val(id){ return document.getElementById(id).value }
      var jx = {
         "firstname":val("firstName"),
         "lastname": val("lastName"),
         "age": val("age")
      }
      var xhttp = new XMLHttpRequest();
      xhttp.open("POST", "%string([wapp-param BASE_URL])/acceptjson", true);
      xhttp.setRequestHeader("Content-Type","text/json");
      xhttp.send(JSON.stringify(jx));
      return false
    }
    </script>
  }
}
proc wapp-page-acceptjson {} {
  puts "Accept Json Called"
  puts "mimetype: [list [wapp-param CONTENT_TYPE]]"
  puts "content: [list [wapp-param CONTENT]]"
}
wapp-start $argv
