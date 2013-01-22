class packages::mozilla::py27_mercurial {

    $mercurial = "/tools/python27-mercurial/bin/hg"

    anchor {
        'packages::mozilla::py27_mercurial::begin': ;
        'packages::mozilla::py27_mercurial::end': ;
    }

    include packages::mozilla::python27

    case $::operatingsystem {
        CentOS: {
            Anchor['packages::mozilla::py27_mercurial::begin'] ->
            package {
                "mozilla-python27-mercurial":
                    ensure => latest,
                    require => Class['packages::mozilla::python27'];
            } -> Anchor['packages::mozilla::py27_mercurial::end']
        }
        Ubuntu: {
            include packages::mercurial
            file {
                ["/tools/python27-mercurial", "/tools/python27-mercurial/bin"]:
                    ensure => directory;
                $mercurial:
                    ensure => link,
                    target => "/usr/bin/hg";
            }
        }
        Darwin: {
            Anchor['packages::mozilla::py27_mercurial::begin'] ->
            packages::pkgdmg {
                python27-mercurial:
                    version => "2.1.1-1";
            } -> Anchor['packages::mozilla::py27_mercurial::end']
        }
        default: {
            fail("cannot install on $::operatingsystem")
        }
    }
}
