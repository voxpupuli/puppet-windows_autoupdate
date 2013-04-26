#
class windows_autoupdate::params {
    $noAutoUpdate = hiera('au_noAutoUpdate','0')
    $aUOptions = hiera('au_aUOptions','4')
    $scheduledInstallDay = hiera('au_scheduledInstallDay','1')
    $scheduledInstallTime = hiera('au_scheduledInstallTime','1')
    $useWUServer = hiera('au_useWUServer','0')
    $rescheduleWaitTime = hiera('au_rescheduleWaitTime','0')
    $noAutoRebootWithLoggedOnUsers = hiera('au_noAutoRebootWithLoggedOnUsers','0')
    $p_reg_key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'
}