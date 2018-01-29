# This script demonstrates how to send form data as JSON using
# XMLHttpRequest
#
package require wapp
proc wapp-default {} {
  wapp-trim {
    <h1>Example Of Sending application/x-www-form-urlencoded Using AJAX</h1>
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
      function val(id){ return escape(document.getElementById(id).value) }
      var jx = "firstname="+val("firstName")+
               "&lastname="+val("lastName")+
               "&age="+val("age");
      var xhttp = new XMLHttpRequest();
      xhttp.open("POST", "%string([wapp-param BASE_URL])/acceptjson", true);
      xhttp.setRequestHeader("Content-Type",
                             "application/x-www-form-urlencoded");
      xhttp.send(jx);
      return false
    }
    </script>
  }
}
proc wapp-page-acceptjson {} {
  global wapp
  puts "Accept Callback"
  puts "mimetype: [list [wapp-param CONTENT_TYPE]]"
  puts "content: [list [wapp-param CONTENT]]"
  foreach var [lsort [dict keys $wapp]] {
    if {![regexp {^[a-z]} $var]} continue
    puts "$var = [list [wapp-param $var]]"
  }
}
wapp-start $argv
