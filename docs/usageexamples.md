Web Applications Using Wapp
===========================

The following are some of the known uses of Wapp in the wild:

  1.  The [checklist](https://sqlite.org/checklists) application used to
      manage testing and release of SQLite is a Wapp script.
      Source code for the checklist
      application is at <https://sqlite.org/checklistapp>.

  2.  The [search feature](https://sqlite.org/search?q=fts5) on the SQLite
      homepage is implemented using a Wapp-script, seen
      [here](https://sqlite.org/docsrc/file/search/search.tcl.in).
      (NB: The search.tcl.in script is processed using
      [mkscript.tcl](https://sqlite.org/docsrc/file/search/mkscript.tcl)
      prior to being deployed.)

  3.  The [TCL-driven tests for SQLite](https://www.sqlite.org/testing.html#test_harnesses)
      have a Wapp-based interface that shows the testing progress.  To see
      this interface in action, get a copy of the SQLite source tree and
      run:

>
      configure
      make testfixture
      tclsh test/wapptest.tcl
