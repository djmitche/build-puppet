# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
class tweaks::windows_sendchange_hack {

    include buildslave::install

    # Hack to for successful sendchange
    # Ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1175701
    # Ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1199267#c89
    file {
        'C:\mozilla-build\python27\Lib\site-packages\zope':
            require => Class["buildslave::install"],
            ensure => directory,
            recurse => true,
            source => "C:\\mozilla-build\\buildbotve\\Lib\\site-packages\\zope",
    }
    file {
        'C:\mozilla-build\python27\Lib\site-packages\buildbot':
            require => Class["buildslave::install"],
            ensure => directory,
            recurse => true,
            source => "C:\\mozilla-build\\buildbotve\\Lib\\site-packages\\buildbot",
    }
    file {
        'C:\mozilla-build\python27\Lib\site-packages\twisted':
            require => Class["buildslave::install"],
            ensure => directory,
            recurse => true,
            source => "C:\\mozilla-build\\buildbotve\\Lib\\site-packages\\twisted",
    }
    file {
        'C:\mozilla-build\python27\Lib\site-packages\zope.interface-3.6.1-py2.7.egg-info':
            require => Class["buildslave::install"],
            ensure => directory,
            recurse => true,
            source => "C:\\mozilla-build\\buildbotve\\Lib\\site-packages\\zope.interface-3.6.1-py2.7.egg-info",
    }
    file {
        'C:\mozilla-build\python27\Lib\site-packages\Twisted-10.2.0-py2.7.egg-info':
            require => Class["buildslave::install"],
            ensure => directory,
            recurse => true,
            source => "C:\\mozilla-build\\buildbotve\\Lib\\site-packages\\Twisted-10.2.0-py2.7.egg-info",
    }
    file {
        'C:\mozilla-build\python27\Lib\site-packages\zope.interface-3.6.1-py2.7-nspkg.pth':
            require => Class["buildslave::install"],
            ensure => file,
            source => "C:\\mozilla-build\\buildbotve\\Lib\\site-packages\\zope.interface-3.6.1-py2.7-nspkg.pth",
    }
}
