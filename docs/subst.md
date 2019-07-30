Inserting Generated Text Into A Document
========================================

The [wapp-subst](./commands.md#wapp-subst) and 
[wapp-trim](./commands.md#wapp-trim) commands accept various substitution
functions so that generated content can be inserted into the webpage
<i>safely</i>. "Safely" in this context means that characters
having special meaning to HTML or Javascript are escaped.

<center>
<table border="0">
<tr>
<td style='padding-right:5ex;' valign='top'>%html(...)</td>
<td>Excape text for inclusion in HTML</td>
</tr>
<tr>
<td style='padding-right:5ex;' valign='top'>%url(...)</td>
<td>Excape text for use as a URL</td>
</tr>
<tr>
<td style='padding-right:5ex;' valign='top'>%qp(...)</td>
<td>Excape text for use as a URL query parameter</td>
</tr>
<tr>
<td style='padding-right:5ex;' valign='top'>%string(...)</td>
<td>Excape text for use within a JSON string</td>
</tr>
<tr>
<td style='padding-right:5ex;' valign='top'>%unsafe(...)</td>
<td>No transformations of the text</td>
</tr>
</table>
</center>

The arguments to these substitution functions can be any valid TCL
expression.  Except,
the substitutions are recognized using a regular expression which
terminates at the first ")" it sees in the argument.  That means that
the argument cannot use TCL expressions that include a ")" character.
To work around that limitation, the following variants are also
supported:

<center>
<table border="0">
<tr><td>%html%(...)%</td></tr>
<tr><td>%url%(...)%</td></tr>
<tr><td>%qp%(...)%</td></tr>
<tr><td>%string%(...)%</td></tr>
<tr><td>%unsafe%(...)%</td></tr>
</table>
</center>

In other words, the "(...)" argument is replaced with "%(...)%" -
parentheses surrounded by "%" characters.
In these cases, the regular expression terminates at the first ")%" that
it sees, rather than the first ")".  The ")%" character sequence is
is less likely to appear as TCL in the argument and hence these routines
provide added flexibility for complex TCL expressions.

## Examples

Consider this simple Wapp program:

>
    package require wapp
    proc wapp-default {} {
      set var1 {Hello <y'all>}
      wapp-subst {<p>%html($var1)</p>}
    }
    wapp-start $argv

The "var1" variable contains text that cannot be inserted directly
into HTML due to the &lt; and &gt; characters.  But the %html()
substitution escapes these characters so that the generated HTML
looks like this:

>
    <p>Hello &lt;y'all&gt;</p>

Here is an example of a more complex TCL expression used in the argument:

>
    package require wapp
    proc wapp-default {} {
      set a 123
      set b 345
      set c 678
      wapp-subst {<p>expr = %html%([expr {($a+$b)*$c}])%</p>}
    }
    wapp-start $argv

In this case the argument contains a ")" character and so it is necessary
to use the %html%(...)% form of the substitution to prevent the regular
expression stopping at the first ")" and thus truncating the TCL
expression as just "`[expr {($a+$b1`".
