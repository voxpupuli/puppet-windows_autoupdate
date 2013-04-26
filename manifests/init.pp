# Class windows_autoupdate
#
# This class configure windows autoupdate services
#
class windows_autoupdate(
    $noAutoUpdate = 'UNSET',
    $aUOptions = 'UNSET',
    $scheduledInstallDay = 'UNSET',
    $scheduledInstallTime = 'UNSET',
    $useWUServer = 'UNSET',
    $rescheduleWaitTime = 'UNSET',
    $noAutoRebootWithLoggedOnUsers = 'UNSET'
) {
    
    include windows_autoupdate::params
    
    $fixed_noAutoUpdate = $noAutoUpdate ? {
        'UNSET' => $windows_autoupdate::params::noAutoUpdate,
        default => $noAutoUpdate
    }
    
    $fixed_aUOptions = $aUOptions ? {
        'UNSET' => $windows_autoupdate::params::aUOptions,
        default => $aUOptions
    }
    
    $fixed_scheduledInstallDay = $scheduledInstallDay ? {
        'UNSET' => $windows_autoupdate::params::scheduledInstallDay,
        default => $scheduledInstallDay
    }
    
    $fixed_scheduledInstallTime = $scheduledInstallTime ? {
        'UNSET' => $windows_autoupdate::params::scheduledInstallTime,
        default => $scheduledInstallTime
    }
    
    $fixed_useWUServer = $useWUServer ? {
        'UNSET' => $windows_autoupdate::params::useWUServer,
        default => $useWUServer
    }
    
    $fixed_rescheduleWaitTime = $rescheduleWaitTime ? {
        'UNSET' => $windows_autoupdate::params::rescheduleWaitTime,
        default => $rescheduleWaitTime
    }
    
    $fixed_noAutoRebootWithLoggedOnUsers = $noAutoRebootWithLoggedOnUsers ? {
        'UNSET' => $windows_autoupdate::params::noAutoRebootWithLoggedOnUsers,
        default => $noAutoRebootWithLoggedOnUsers
    }
    
    validate_re($fixed_noAutoUpdate,['^[0,1]$'])
    validate_re($fixed_aUOptions,['^[1-4]$'])
    validate_re($fixed_scheduledInstallDay,['^[0-7]$'])
    validate_re($fixed_scheduledInstallTime,['^[0-23]$'])
    validate_re($fixed_useWUServer,['^[0,1]$'])
    validate_re($fixed_rescheduleWaitTime,['^[1-60]$'])
    validate_re($fixed_noAutoRebootWithLoggedOnUsers,['^[0,1]$'])
    
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
      data   => $fixed_noAutoUpdate,
    }
    
    registry_value { 'AUOptions':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\AUOptions",
      type   => 'dword',
      data   => $fixed_aUOptions
    }
    
    registry_value { 'ScheduledInstallDay':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\ScheduledInstallDay",
      type   => 'dword',
      data   => $fixed_scheduledInstallDay,
    }
    
    registry_value { 'ScheduledInstallTime':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\ScheduledInstallTime",
      type   => 'dword',
      data   => $fixed_scheduledInstallTime,
    }
    
    registry_value { 'UseWUServer':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\UseWUServer",
      type   => 'dword',
      data   => $fixed_useWUServer
    }
    
    registry_value { 'RescheduleWaitTime':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\RescheduleWaitTime",
      type   => 'dword',
      data   => $fixed_rescheduleWaitTime
    }
    
    registry_value { 'NoAutoRebootWithLoggedOnUsers':
      ensure => present,
      path   => "${windows_autoupdate::params::p_reg_key}\NoAutoRebootWithLoggedOnUsers",
      type   => 'dword',
      data   => $fixed_noAutoRebootWithLoggedOnUsers
    }
}