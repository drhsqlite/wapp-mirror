Hints For Debugging Wapp Applications
=====================================

Here are some suggestions for debugging Wapp applications:

  +  If it seems like the [wapp-param](commands.md#wapp-param) command is not 
     working correctly, that might be because the same-origin policy
     is preventing query parameters from being parsed.
     Try adding the [wapp-allow-xorigin-parameters](commands.md#allow-xorigin)
     command to the top of the page generator proc, at
     least temporarily, to see if that clears the problem.

  +  If parts of your webpage do not appear to be working, that might
     be due to the restrictive default 
     [Content Security Policy (CSP)](https://en.wikipedia.org/wiki/Content_Security_Policy)
     that Wapp uses.  Try temporarily disabling the CSP using a command
     like <blockquote><b>wapp-content-security-policy off</b></blockquote>
     near the top of your page-generator proc.

  +  Temporarily insert the output of the 
     [wapp-debug-env](commands.md#debug-env) command in your output to see
     what is going on.  Example:
     
> > 
    wapp-trim {
      <h1>Environment</h1>
      <pre>%html([wapp-debug-env])</pre>
    }
