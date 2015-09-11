# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   MIT

# == Class windows_autoupdate::params
#
# This private class is meant to be called from `windows_autoupdate`
# It sets variables according to platform
#
class windows_autoupdate::params {

  $noAutoUpdate = '0'
  $aUOptions = '4'
  $scheduledInstallDay = '1'
  $scheduledInstallTime = '10'
  $useWUServer = '0'
  $wUServer = ''
  $wUStatusServer = ''
  $rescheduleWaitTime = '10'
  $noAutoRebootWithLoggedOnUsers = '0'

  $p_reg_policies = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
  $p_reg_policies64 = 'HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate'

  if $::operatingsystemrelease == 'Server 2012' or $::operatingsystemrelease == '2012 R2' {
    $p_reg_key = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'
    $p_reg_keyServ = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate'
  } else {
    $p_reg_key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
    $p_reg_keyServ = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
  }

}
