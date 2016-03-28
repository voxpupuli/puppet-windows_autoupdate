# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   MIT

# == Class: windows_autoupdate
#
# Module to mananage the configuration of a machines autoupdate settings
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*no_auto_update*]
# Ensuring the state of automatic updates.
# 0: Automatic Updates is enabled (default)
# 1: Automatic Updates is disabled.
#
# [*au_options*]
# The option to configure what to do when an update is avaliable
# 1: Keep my computer up to date has been disabled in Automatic Updates.
# 2: Notify of download and installation.
# 3: Automatically download and notify of installation.
# 4: Automatically download and scheduled installation.
#
# [*scheduled_install_day*]
# The day of the week to install updates.
# 0: Every day.
# 1 through 7: The days of the week from Sunday (1) to Saturday (7).
#
# [*scheduled_install_time*]
# The time of day (in 24hr format) when to install updates.
#
# [*use_wuserver*]
# If set to 1, windows autoupdates will use a local WSUS server rather than windows update.
#
# [*reschedule_wait_time*]
# The time period to wait between the time Automatic Updates starts and the time it begins installations
# where the scheduled times have passed. The time is set in minutes from 1 to 60
#
# [*no_auto_reboot_with_logged_on_users*]
# If set to 1, Automatic Updates does not automatically restart a computer while users are logged on.
#
# === Examples
#
# Manage autoupdates with windows default settings:
#
#   include windows_autoupdate
#
# Disable auto updates (don't do this!):
#
#   class { 'windows_autoupdate': no_auto_update => '1' }
#
class windows_autoupdate(
  $au_options                          = $windows_autoupdate::params::au_options,
  $no_auto_reboot_with_logged_on_users = $windows_autoupdate::params::no_auto_reboot_with_logged_on_users,
  $no_auto_update                      = $windows_autoupdate::params::no_auto_update,
  $reschedule_wait_time                = $windows_autoupdate::params::reschedule_wait_time,
  $scheduled_install_day               = $windows_autoupdate::params::scheduled_install_day,
  $scheduled_install_time              = $windows_autoupdate::params::scheduled_install_time,
  $use_wuserver                        = $windows_autoupdate::params::use_wuserver,
) inherits windows_autoupdate::params {

  validate_re($no_auto_update,['^[0,1]$'])
  validate_re($au_options,['^[1-4]$'])
  validate_re($scheduled_install_day,['^[0-7]$'])
  validate_re($scheduled_install_time,['^(2[0-3]|1?[0-9])$'])
  validate_re($use_wuserver,['^[0,1]$'])
  validate_re($reschedule_wait_time,['^(60|[1-5][0-9]|[1-9])$'])
  validate_re($no_auto_reboot_with_logged_on_users,['^[0,1]$'])

  service { 'wuauserv':
    ensure    => 'running',
    enable    => true,
    subscribe => Registry_value['NoAutoUpdate','AUOptions','ScheduledInstallDay', 'ScheduledInstallTime','UseWUServer','RescheduleWaitTime','NoAutoRebootWithLoggedOnUsers'],
  }

  registry_key { $windows_autoupdate::params::p_reg_key:
    ensure => present,
  }

  registry_value { 'NoAutoUpdate':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\NoAutoUpdate",
    type   => 'dword',
    data   => $no_auto_update,
  }

  registry_value { 'AUOptions':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\AUOptions",
    type   => 'dword',
    data   => $au_options,
  }

  registry_value { 'ScheduledInstallDay':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\ScheduledInstallDay",
    type   => 'dword',
    data   => $scheduled_install_day,
  }

  registry_value { 'ScheduledInstallTime':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\ScheduledInstallTime",
    type   => 'dword',
    data   => $scheduled_install_time,
  }

  registry_value { 'UseWUServer':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\UseWUServer",
    type   => 'dword',
    data   => $use_wuserver,
  }

  registry_value { 'RescheduleWaitTime':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\RescheduleWaitTime",
    type   => 'dword',
    data   => $reschedule_wait_time,
  }

  registry_value { 'NoAutoRebootWithLoggedOnUsers':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\NoAutoRebootWithLoggedOnUsers",
    type   => 'dword',
    data   => $no_auto_reboot_with_logged_on_users,
  }
}
