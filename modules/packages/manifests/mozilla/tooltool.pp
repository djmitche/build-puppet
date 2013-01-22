class packages::mozilla::tooltool {
    include packages::mozilla::python27
    include users::root
    # this package is simple enough that its source code is embedded in the
    # puppet repo.  It gets the Python intepreter added to its shebang line
    $python = $::packages::mozilla::python27::python
    file {
        "/tools/tooltool.py":
            owner => $users::root::username,
            group => $users::root::group,
            mode => 0755,
            content => template("packages/tooltool.py");
    }
}
