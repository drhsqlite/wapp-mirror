Security Considerations
=======================

Wapp strives for security by default.  Applications can disable security
features on an as-needed basis, but the default setting for security
features is always "on".

Security features in Wapp include the following:

  1.  The default
      [Content Security Policy](https://en.wikipedia.org/wiki/Content_Security_Policy)
      of "CSP"
      for all Wapp applications is _default\_src 'self'_.  In that mode,
      resources must all be loaded from the same origin, the use of
      eval() and similar commands in javascript is prohibited, and
      no in-line javascript or CSS is allowed.  These limitations help
      keep applications safe from 
      [XSS attacks](https://en.wikipedia.org/wiki/Cross-site_scripting)
      attacks, even in the face of application coding errors. If these
      restrictions are too severe for an application, the CSP can be
      relaxed using the "wapp-content-security-policy" command.

  2.  Access to GET query parameters and POST parameters is prohibited
      unless the origin of the request is the application itself, as
      determined by the Referrer field in the HTTP header. This feature
      helps to prevent
      [Cross-site Request Forgery](https://en.wikipedia.org/wiki/Cross-site_request_forgery)
      attacks. The "wapp-allow-xorigin-params" command can be used to
      disable this protection on a case-by-case basis.

  3.  Cookies, query parameters, and POST parameters are automatically
      decoded before they reach application code. There is no risk
      that the application program will forget a decoding step or
      accidently miscode a decoding operation.

  4.  Reply text generated using the "wapp-subst" and "wapp-trim" commands
      automatically escapes generated text so that it is safe for inclusion
      within HTML, within a javascript or JSON string literal, as a URL,
      or as the value of a query parameter. As long as the application
      programmer is careful to always use "wapp-subst" and/or "wapp-trim"
      to generate replies, there is little risk of injection attacks.

  5.  If the application is launched on a command-line with the --trim
      option, then instead of running the application, Wapp scans the
      application code looking for constructs that are unsafe.  Unsafe
      constructs include things such as using "wapp-subst" with an argument
      that is not contained within {...}.

Part of what makes Wapp easy to use is that it helps free application
developers from the worry of accidently introducing security vulnerabilities
via programming errors.  Of course, no framework is fool-proof.  Developers
still must be aware of security.  Wapp does not prevent every error, but
it does help make writing a secure application easier and less stressful.
