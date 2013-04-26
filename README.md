Puppet module for managing [Microsoft Windows Automatic Updates](http://support.microsoft.com/kb/328010).

This module is also available on the [Puppet Forge](https://forge.puppetlabs.com/liamjbennett/windows_autoupdate)

[![Build
Status](https://secure.travis-ci.org/liamjbennett/puppet-windows_autoupdate_.png)](http://travis-ci.org/liamjbennett/puppet-windows_autoupdate_)
[![Dependency
Status](https://gemnasium.com/liamjbennett/puppet-windows_autoupdate_.png)](http://gemnasium.com/liamjbennett/puppet-windows_autoupdate_)

## Configuration ##
The windows_autoupdate class has some defaults that can be overridden, for instance if you wanted to disable autoupdates you could do the following:

	class { 'windows_autoupdate': noAutoUpdate => '1' }
