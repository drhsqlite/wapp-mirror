Wapp Commands
=============

Wapp really just a collection of TCL procs.  All procs are in a single file
named "wapp.tcl".

The procs that form the public interface for Wapp begin with "wapp-".  The
implementation uses various private procedures that have names beginning
with "wappInt-".  Applications should use the public interface only.

The most important Wapp interfaces are:

  +  **wapp-start**
  +  **wapp-subst** and **wapp-trim**
  +  **wapp-param**

Understand the four interfaces above, and you will have a good understanding
of Wapp.  The other interfaces are merely details.

The following is a complete list of the public interface procs in Wapp:

  +  **wapp-start** _ARGLIST_  
     Start up the application.  _ARGLIST_ is typically the value of $::argv,
     though it might be some subset of $::argv if the containing application
     has already processed some command-line parameters for itself.  By default,
     this proc never returns, and so it should be very last command in the
     application script.  To embed Wapp in a larger application, include
     the -nowait option in _ARGLIST_ and this proc will return immediately
     after setting up all necessary file events.

  +  <a name='wapp-subst'></a>**wapp-subst** _TEXT_  
     This command appends text to the end of reply to an HTTP request.
     The _TEXT_ argument should be enclosed in {...} to prevent 
     accidental substitutions.
     The "wapp-subst" command itself will do all necessary backslash
     substitutions.  Command and variable substitutions occur within
     "%html(...)", "%url(...)", "%qp(...)", "%string(...)", and
     "%unsafe(...)".  The substitutions are escaped (except in the case of
     "%unsafe(...)") so that the result is safe for inclusion within the
     body of an HTML document, a URL, a query parameter, or a javascript or
     JSON string literal, respectively. 

> >  <b>Caution #1:</b> When using Tcl 8.6 or
     earlier, command substitution, but not variable substitution, occurs
     outside of the quoted regions. This problem is fixed using the new
     "-command" option to the regsub command in Tcl 8.7.  Nevertheless, 
     it is suggested that you avoid using the "[" character outside of
     the %-quotes.  Use "\&#91;" instead.

> >  <b>Caution #2:</b> The %html() and similar %-substitutions are parsed
     using a regexp, which means that they cannot do matching parentheses.
     The %-substitution is terminated by the first close parenthesis, not the
     first matching close-parenthesis.

  +  **wapp-trim** _TEXT_  
     Just like wapp-subst, this routine appends _TEXT_ to the web page
     under construction, using the %html, %url, %qp, %string, and %unsafe
     substitutions.  The difference is that this routine also removes
     surplus whitespace from the left margin, so that if the _TEXT_
     argument is indented in the source script, it will appear at the
     left margin in the generated output.

  +  <a name='wapp-param'></a>**wapp-param** _NAME_ _DEFAULT_  
     Return the value of the [Wapp parameter](params.md) _NAME_,
     or return _DEFAULT_ if there is no such query parameter or environment
     variable.  If _DEFAULT_ is omitted, then it is an empty string.

  +  **wapp-set-param** _NAME_ _VALUE_  
     Change the value of parameter _NAME_ to _VALUE_.  If _NAME_ does not
     currently exist, it is created.

  +  **wapp-param-exists** _NAME_  
     Return true if and only if a parameter called _NAME_ exists for the
     current request.

  +  **wapp-param-list** _NAME_  
     Return a TCL list containing the names of all parameters for the current
     request.  Note that there are several parameters that Wapp uses
     internally.  Those internal-use parameters all have names that begin
     with ".".

  +  <a name='allow-xorigin'></a>**wapp-allow-xorigin-params**  
     Query parameters and POST parameters are usually only parsed and added
     to the set of parameters available to "wapp-param" for same-origin
     requests.  This restriction helps prevent cross-site request forgery
     (CSRF) attacks.  Query-only web pages for which it is safe to accept
     cross-site query parameters can invoke this routine to cause query
     parameters to be decoded.

  +  **wapp-mimetype** _MIMETYPE_  
     Set the MIME-type for the generated web page.  The default is "text/html".

  +  **wapp-reply-code** _CODE_  
     Set the reply-code for the HTTP request.  The default is "200 Ok".

  +  **wapp-redirect** _TARGET-URL_  
     Cause an HTTP redirect to _TARGET-URL_.

  +  **wapp-reset**  
     Reset the web page under construction back to an empty string.

  +  **wapp-set-cookie** _NAME_ _VALUE_  
     Cause the cookie _NAME_ to be set to _VALUE_.

  +  **wapp-clear-cookie** _NAME_  
     Erase the cookie _NAME_.

  +  **wapp-safety-check**  
     Examine all TCL procedures in the application and return a text string
     containing warnings about unsafe usage of Wapp commands.  This command
     is run automatically if the "wapp-start" command is invoked with a --lint
     option.

  +  **wapp-cache-control** _CONTROL_  
     The _CONTROL_ argument should be one of "no-cache", "max-age=N", or
     "private,max-age=N", where N is an integer number of seconds.

  +  <a name='csp'></a>**wapp-content-security-policy** _POLICY_  
     Set the Content Security Policy (hereafter "CSP") to _POLICY_.  The
     default CSP is _default\_src 'self'_, which is very restrictive.  The
     default CSP disallows (a) loading any resources from other origins,
     (b) the use of eval(), and (c) in-line javascript or CSS of any kind.
     Set _POLICY_ to "off" to completely disable the CSP mechanism.  Or
     specify some other policy suitable for the needs of the application.


  +  <a name="debug-env"></a>**wapp-debug-env**  
     This routine returns text that describes all of the Wapp parameters.
     Use it to get a parameter dump for troubleshooting purposes.

  +  **wapp** _TEXT_  
     Add _TEXT_ to the web page output currently under construction.  _TEXT_
     must not contain any TCL variable or command substitutions.  This command
     is rarely used.

  +  **wapp-unsafe** _TEXT_  
     Add _TEXT_ to the web page under construction even though _TEXT_ does
     contain TCL variable and command substitutions.  The application developer
     must ensure that the variable and command substitutions does not allow
     XSS attacks.  Avoid using this command.  The use of "wapp-subst" is 
     preferred in most situations.
