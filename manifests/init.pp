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
# [*noAutoUpdate*]
# Ensuring the state of automatic updates.
# 0: Automatic Updates is enabled (default)
# 1: Automatic Updates is disabled.
#
# [*aUOptions*]
# The option to configure what to do when an update is avaliable
# 1: Keep my computer up to date has been disabled in Automatic Updates.
# 2: Notify of download and installation.
# 3: Automatically download and notify of installation.
# 4: Automatically download and scheduled installation.
#
# [*scheduledInstallDay*]
# The day of the week to install updates.
# 0: Every day.
# 1 through 7: The days of the week from Sunday (1) to Saturday (7).
#
# [*scheduledInstallTime*]
# The time of day (in 24hr format) when to install updates.
#
# [*useWUServer*]
# If set to 1, windows autoupdates will use a local WSUS server rather than windows update.
#
# [*rescheduleWaitTime*]
# The time period to wait between the time Automatic Updates starts and the time it begins installations
# where the scheduled times have passed. The time is set in minutes from 1 to 60
#
# [*noAutoRebootWithLoggedOnUsers*]
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
#   class { 'windows_autoupdate': noAutoUpdate => '1' }
#
class windows_autoupdate(
  $noAutoUpdate                  = $windows_autoupdate::params::noAutoUpdate,
  $aUOptions                     = $windows_autoupdate::params::aUOptions,
  $scheduledInstallDay           = $windows_autoupdate::params::scheduledInstallDay,
  $scheduledInstallTime          = $windows_autoupdate::params::scheduledInstallTime,
  $useWUServer                   = $windows_autoupdate::params::useWUServer,
  $rescheduleWaitTime            = $windows_autoupdate::params::rescheduleWaitTime,
  $noAutoRebootWithLoggedOnUsers = $windows_autoupdate::params::noAutoRebootWithLoggedOnUsers
) inherits windows_autoupdate::params {

  validate_re($noAutoUpdate,['^[0,1]$'])
  validate_re($aUOptions,['^[1-4]$'])
  validate_re($scheduledInstallDay,['^[0-7]$'])
  validate_re($scheduledInstallTime,['^(2[0-3]|1?[0-9])$'])
  validate_re($useWUServer,['^[0,1]$'])
  validate_re($rescheduleWaitTime,['^(60|[1-5][0-9]|[1-9])$'])
  validate_re($noAutoRebootWithLoggedOnUsers,['^[0,1]$'])

  service { 'wuauserv':
    ensure    => 'running',
    enable    => true,
    subscribe => Registry_value['NoAutoUpdate','AUOptions','ScheduledInstallDay', 'ScheduledInstallTime','UseWUServer','RescheduleWaitTime','NoAutoRebootWithLoggedOnUsers']
  }

  registry_key { $windows_autoupdate::params::p_reg_key:
    ensure => present
  }

  registry_value { 'NoAutoUpdate':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\NoAutoUpdate",
    type   => 'dword',
    data   => $noAutoUpdate
  }

  registry_value { 'AUOptions':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\AUOptions",
    type   => 'dword',
    data   => $aUOptions
  }

  registry_value { 'ScheduledInstallDay':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\ScheduledInstallDay",
    type   => 'dword',
    data   => $scheduledInstallDay
  }

  registry_value { 'ScheduledInstallTime':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\ScheduledInstallTime",
    type   => 'dword',
    data   => $scheduledInstallTime
  }

  registry_value { 'UseWUServer':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\UseWUServer",
    type   => 'dword',
    data   => $useWUServer
  }

  registry_value { 'RescheduleWaitTime':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\RescheduleWaitTime",
    type   => 'dword',
    data   => $rescheduleWaitTime
  }

  registry_value { 'NoAutoRebootWithLoggedOnUsers':
    ensure => present,
    path   => "${windows_autoupdate::params::p_reg_key}\\NoAutoRebootWithLoggedOnUsers",
    type   => 'dword',
    data   => $noAutoRebootWithLoggedOnUsers
  }
}
