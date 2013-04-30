# Class windows_autoupdate
#
# This class configure windows autoupdate services
#
class windows_autoupdate(
    $noAutoUpdate = $windows_autoupdate::params::noAutoUpdate,
    $aUOptions = $windows_autoupdate::params::aUOptions,
    $scheduledInstallDay = $windows_autoupdate::params::scheduledInstallDay,
    $scheduledInstallTime = $windows_autoupdate::params::scheduledInstallTime,
    $useWUServer = $windows_autoupdate::params::useWUServer,
    $rescheduleWaitTime = $windows_autoupdate::params::rescheduleWaitTime,
    $noAutoRebootWithLoggedOnUsers = $windows_autoupdate::params::noAutoRebootWithLoggedOnUsers
) inherits windows_autoupdate::params {
    
    validate_re($noAutoUpdate,['^[0,1]$'])
    validate_re($aUOptions,['^[1-4]$'])
    validate_re($scheduledInstallDay,['^[0-7]$'])
    validate_re($scheduledInstallTime,['^[0-23]$'])
    validate_re($useWUServer,['^[0,1]$'])
    validate_re($rescheduleWaitTime,['^[1-60]$'])
    validate_re($noAutoRebootWithLoggedOnUsers,['^[0,1]$'])
    
    service { 'wuauserv':
      ensure    => 'running',
      enable    => true,
      subscribe => Registry_value['NoAutoUpdate','AUOptions','ScheduledInstallDay',
                                  'ScheduledInstallTime','UseWUServer','RescheduleWaitTime','NoAutoRebootWithLoggedOnUsers'] 
    }
    
    registry_key { $windows_autoupdate::params::p_reg_key:
      ensure => present,
    }
    
    registry_value { 'NoAutoUpdate':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\NoAutoUpdate",
      type   => 'dword',
      data   => $noAutoUpdate,
    }
    
    registry_value { 'AUOptions':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\AUOptions",
      type   => 'dword',
      data   => $aUOptions
    }
    
    registry_value { 'ScheduledInstallDay':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\ScheduledInstallDay",
      type   => 'dword',
      data   => $scheduledInstallDay,
    }
    
    registry_value { 'ScheduledInstallTime':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\ScheduledInstallTime",
      type   => 'dword',
      data   => $scheduledInstallTime,
    }
    
    registry_value { 'UseWUServer':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\UseWUServer",
      type   => 'dword',
      data   => $useWUServer
    }
    
    registry_value { 'RescheduleWaitTime':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\RescheduleWaitTime",
      type   => 'dword',
      data   => $rescheduleWaitTime
    }
    
    registry_value { 'NoAutoRebootWithLoggedOnUsers':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\NoAutoRebootWithLoggedOnUsers",
      type   => 'dword',
      data   => $noAutoRebootWithLoggedOnUsers
    }
}