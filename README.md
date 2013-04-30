Puppet module for managing [Microsoft Windows Automatic Updates](http://support.microsoft.com/kb/328010).

This module is also available on the [Puppet Forge](https://forge.puppetlabs.com/liamjbennett/windows_autoupdate)

[![Build
Status](https://secure.travis-ci.org/liamjbennett/puppet-windows_autoupdate.png)](http://travis-ci.org/liamjbennett/puppet-windows_autoupdate)
[![Dependency
Status](https://gemnasium.com/liamjbennett/puppet-windows_autoupdate.png)](http://gemnasium.com/liamjbennett/puppet-windows_autoupdate)


## Configuration ##
The windows_autoupdate class has some defaults that can be overridden, for instance if you wanted to disable autoupdates you could do the following:

	class { 'windows_autoupdate': noAutoUpdate => '1' }

## Requirements ##

Tested against puppet versions 2.7.x and 3.x.x

These modules will also get installed as a dependency for this module:

puppetlabs/stdlib
joshcooper/powershell
liamjbennett/win_facts

Please see the ModuleFile for further details.