Wapp Limitations
================

The current Wapp implementation has the following limitations:

  1.   The actual page generation step is single threaded.  Multiple
       connections can be incoming and multiple replies can be in-flight
       at the same time.  But the generation of each reply happens all
       at once.
       <p>
       This limitation can be worked around by deploying the Wapp application
       using CGI, such that each HTTP request is handled by a separate
       process.
