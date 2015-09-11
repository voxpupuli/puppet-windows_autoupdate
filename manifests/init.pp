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
# [*wUServer*]
# If useWUServer is set to 1, windows autoupdates will use THIS local WSUS server rather than windows update.
#
# [*wUStatusServer*]
# If useWUServer is set to 1, windows autoupdates will use THIS local WSUS status server rather than windows update.
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
  $wUServer                      = $windows_autoupdate::params::wUServer,
  $wUStatusServer                = $windows_autoupdate::params::wUStatusServer,
  $rescheduleWaitTime            = $windows_autoupdate::params::rescheduleWaitTime,
  $noAutoRebootWithLoggedOnUsers = $windows_autoupdate::params::noAutoRebootWithLoggedOnUsers
) inherits windows_autoupdate::params {

  validate_re($noAutoUpdate,['^[0,1]$'])
  validate_re($aUOptions,['^[1-4]$'])
  validate_re($scheduledInstallDay,['^[0-7]$'])
  validate_re($scheduledInstallTime,['^(2[0-3]|1?[0-9])$'])
  validate_re($useWUServer,['^[0,1]$'])
  validate_re($wUServer,['^*$'])
  validate_re($wUStatusServer,['^*$'])
  validate_re($rescheduleWaitTime,['^(60|[1-5][0-9]|[1-9])$'])
  validate_re($noAutoRebootWithLoggedOnUsers,['^[0,1]$'])

  service { 'wuauserv':
    ensure    => 'running',
    enable    => true,
    subscribe => Registry_value["${windows_autoupdate::params::p_reg_key}\\NoAutoUpdate",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\NoAutoUpdate",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\NoAutoUpdate",
                                "${windows_autoupdate::params::p_reg_key}\\AUOptions",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\AUOptions",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\AUOptions",
                                "${windows_autoupdate::params::p_reg_key}\\ScheduledInstallDay",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\ScheduledInstallDay",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\ScheduledInstallDay",
                                "${windows_autoupdate::params::p_reg_key}\\ScheduledInstallTime",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\ScheduledInstallTime",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\ScheduledInstallTime",
                                "${windows_autoupdate::params::p_reg_keyServ}\\WUServer",
                                "${windows_autoupdate::params::p_reg_policies}\\WUServer",
                                "${windows_autoupdate::params::p_reg_policies64}\\WUServer",
                                "${windows_autoupdate::params::p_reg_keyServ}\\WUStatusServer",
                                "${windows_autoupdate::params::p_reg_policies}\\WUStatusServer",
                                "${windows_autoupdate::params::p_reg_policies64}\\WUStatusServer",
                                "${windows_autoupdate::params::p_reg_key}\\RescheduleWaitTime",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\RescheduleWaitTime",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\RescheduleWaitTime",
                                "${windows_autoupdate::params::p_reg_key}\\NoAutoRebootWithLoggedOnUsers",
                                "${windows_autoupdate::params::p_reg_policies}\\AU\\NoAutoRebootWithLoggedOnUsers",
                                "${windows_autoupdate::params::p_reg_policies64}\\AU\\NoAutoRebootWithLoggedOnUsers"]
  }

  registry_key { [$windows_autoupdate::params::p_reg_key,
                  $windows_autoupdate::params::p_reg_keyServ,
                  $windows_autoupdate::params::p_reg_policies,
                  "$windows_autoupdate::params::p_reg_policies\\AU",
                  "$windows_autoupdate::params::p_reg_policies64\\AU",
                  ]:
    ensure => present
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\NoAutoUpdate",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\NoAutoUpdate",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\NoAutoUpdate"
                    ]:
    ensure => present,
    type   => 'dword',
    data   => $noAutoUpdate
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\AUOptions",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\AUOptions",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\AUOptions"
                    ]:
    ensure => present,
    type   => 'dword',
    data   => $aUOptions
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\ScheduledInstallDay",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\ScheduledInstallDay",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\ScheduledInstallDay"
                    ]:
    ensure => present,
    type   => 'dword',
    data   => $scheduledInstallDay
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\ScheduledInstallTime",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\ScheduledInstallTime",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\ScheduledInstallTime"
                    ]:
    ensure => present,
    type   => 'dword',
    data   => $scheduledInstallTime
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\UseWUServer",
                    "${windows_autoupdate::params::p_reg_policies}\\AU\\UseWUServer",
                    "${windows_autoupdate::params::p_reg_policies64}\\AU\\UseWUServer"
                    ]:
    ensure => present,
    type   => 'dword',
    data   => $useWUServer
  }

  if ( $useWUServer == '1') {
    registry_value { ["${windows_autoupdate::params::p_reg_keyServ}\\WUServer",
                      "${windows_autoupdate::params::p_reg_policies}\\WUServer",
                      "${windows_autoupdate::params::p_reg_policies64}\\WUServer"
                      ]:
      ensure => present,
      type   => 'string',
      data   => $wUServer
    }

    registry_value { ["${windows_autoupdate::params::p_reg_keyServ}\\WUStatusServer",
                      "${windows_autoupdate::params::p_reg_policies}\\WUStatusServer",
                      "${windows_autoupdate::params::p_reg_policies64}\\WUStatusServer"
                      ]:
      ensure => present,
      type   => 'string',
      data   => $wUStatusServer
    }
  } else {
    registry_value { ["${windows_autoupdate::params::p_reg_keyServ}\\WUServer",
                      "${windows_autoupdate::params::p_reg_policies}\\WUServer",
                      "${windows_autoupdate::params::p_reg_policies64}\\WUServer",
                      "${windows_autoupdate::params::p_reg_keyServ}\\WUStatusServer",
                      "${windows_autoupdate::params::p_reg_policies}\\WUStatusServer",
                      "${windows_autoupdate::params::p_reg_policies64}\\WUStatusServer"
                      ]:
      ensure => absent,
    }
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\RescheduleWaitTime",
                      "${windows_autoupdate::params::p_reg_policies}\\AU\\RescheduleWaitTime",
                      "${windows_autoupdate::params::p_reg_policies64}\\AU\\RescheduleWaitTime"
                      ]:
    ensure => present,
    type   => 'dword',
    data   => $rescheduleWaitTime
  }

  registry_value { ["${windows_autoupdate::params::p_reg_key}\\NoAutoRebootWithLoggedOnUsers",
                      "${windows_autoupdate::params::p_reg_policies}\\AU\\NoAutoRebootWithLoggedOnUsers",
                      "${windows_autoupdate::params::p_reg_policies64}\\AU\\NoAutoRebootWithLoggedOnUsers"
                      ]:
    ensure => present,
    type   => 'dword',
    data   => $noAutoRebootWithLoggedOnUsers
  }
}
