Security Considerations
=======================

Wapp strives for security by default.  Applications can disable security
features on an as-needed basis, but the default setting for security
features is always "on".

Security features in Wapp include:

  1.  The default
      [Content Security Policy](https://en.wikipedia.org/wiki/Content_Security_Policy)
      of "CSP"
      for all Wapp applications is _default-src 'self'_.  In that mode,
      resources must all be loaded from the same origin, the use of
      eval() and similar commands in javascript is prohibited, and
      no in-line javascript or CSS is allowed.  These limitations help
      keep applications safe from 
      [XSS attacks](https://en.wikipedia.org/wiki/Cross-site_scripting)
      attacks, even in the face of application coding errors. If these
      restrictions are too severe for an application, the CSP can be
      relaxed or disabled using the 
      "[wapp-content-security-policy](commands.md#csp)" command.

  2.  Access to GET query parameters and POST parameters is prohibited
      unless the origin of the request is the application itself, as
      determined by the Referrer field in the HTTP header. This feature
      helps to prevent
      [Cross-site Request Forgery](https://en.wikipedia.org/wiki/Cross-site_request_forgery)
      attacks. The 
      "[wapp-allow-xorigin-params](commands.md#allow-xorigin)" command 
      can be used to disable this protection on a case-by-case basis.

  3.  Cookies, query parameters, and POST parameters are automatically
      decoded before they reach application code. There is no risk
      that the application program will forget a decoding step or
      accidently miscode a decoding operation.

  4.  Cookies, query parameters, and POST parameters are silently discarded
      unless their names begin with a lower-case letter and contain only
      alphanumerics, underscores, and minus-signs.  Hence, there is no risk
      that unusual parameter names can cause quoting problems or other
      vulnerabilities.

  5.  Reply text generated using the "[wapp-subst](commands.md#wapp-subst)"
      and "[wapp-trim](commands.md#wapp-trim)" commands
      automatically escapes generated text so that it is safe for inclusion
      within HTML, within a javascript or JSON string literal, as a URL,
      or as the value of a query parameter. As long as the application
      programmer is careful to always use "wapp-subst" and/or "wapp-trim"
      to generate replies, there is little risk of injection attacks.

  6.  If the application is launched on a command-line with the --lint
      option, then instead of running the application, Wapp scans the
      application code looking for constructs that are unsafe.  Unsafe
      constructs include things such as using 
      "[wapp-subst](commands.md#wapp-subst)" with an argument
      that is not contained within {...}.

  7.  The new (non-standard) SAME\_ORIGIN variable is provided. This variable
      has a value of "1" or "0" depending on whether or not the current HTTP
      request comes from the same origin. Applications can use this information
      to enhance their own security precautions by refusing to provide sensitive
      information or perform sensitive actions if SAME\_ORIGIN is not "1".

  8.  The --scgi mode only accepts SCGI requests from localhost.  This prevents
      an attacker from sending an SCGI request directly to the script and bypassing
      the webserver in the event that the site firewall is misconfigured or omitted.

  9.  Though cookies, query parameters and POST parameters are accessed using
      the same mechanism as CGI variables, the CGI variable names use a disjoint
      namespace.  (CGI variables are all upper-case and all others are lower-case.)
      Hence, it is not possible for a remote attacher to create a fake CGI variable 
      or override the value of a CGI variable.


Part of what makes Wapp easy to use is that it helps free application
developers from the worry of accidently introducing security vulnerabilities
via programming errors.  Of course, no framework is fool-proof.  Developers
still must be aware of security.  Wapp does not prevent every error, but
it does help make writing a secure application easier and less stressful.
