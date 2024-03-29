# frozen_string_literal: true

require 'spec_helper'

p_reg_key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'

invalid_params = {
  'no_auto_update' => '100',
  'au_options' => '100',
  'scheduled_install_day' => '100',
  'scheduled_install_time' => '100',
  'use_wuserver' => '100',
  'reschedule_wait_time' => '100',
  'no_auto_reboot_with_logged_on_users' => '100'
}

describe 'windows_autoupdate', type: :class do
  let :facts do
    { operatingsystemrelease: '2008 R2' }
  end

  context 'basic requirements' do
    let :params do
      { no_auto_update: '0', au_options: '4', scheduled_install_day: '1',
        scheduled_install_time: '1', use_wuserver: '0', reschedule_wait_time: '10',
        no_auto_reboot_with_logged_on_users: '0' }
    end

    it { is_expected.to contain_registry_key(p_reg_key) }

    it do
      is_expected.to contain_registry_value('NoAutoUpdate').with(
        'ensure' => 'present',
        'path' => "#{p_reg_key}\\NoAutoUpdate",
        'type' => 'dword',
        'data' => 0
      )
    end

    it do
      is_expected.to contain_registry_value('AUOptions').with(
        'ensure' => 'present',
        'path' => "#{p_reg_key}\\AUOptions",
        'type' => 'dword',
        'data' => 4
      )
    end

    it do
      is_expected.to contain_registry_value('ScheduledInstallDay').with(
        'ensure' => 'present',
        'path' => "#{p_reg_key}\\ScheduledInstallDay",
        'type' => 'dword',
        'data' => 1
      )
    end

    it do
      is_expected.to contain_registry_value('UseWUServer').with(
        'ensure' => 'present',
        'path' => "#{p_reg_key}\\UseWUServer",
        'type' => 'dword',
        'data' => 0
      )
    end

    it do
      is_expected.to contain_registry_value('RescheduleWaitTime').with(
        'ensure' => 'present',
        'path' => "#{p_reg_key}\\RescheduleWaitTime",
        'type' => 'dword',
        'data' => 10
      )
    end

    it do
      is_expected.to contain_registry_value('NoAutoRebootWithLoggedOnUsers').with(
        'ensure' => 'present',
        'path' => "#{p_reg_key}\\NoAutoRebootWithLoggedOnUsers",
        'type' => 'dword',
        'data' => 0
      )
    end

    it do
      is_expected.to contain_service('wuauserv').with(
        'ensure' => 'running',
        'enable' => 'true'
      )
    end
  end

  context 'passing custom params' do
    let :params do
      {
        no_auto_update: '1',
        au_options: '1',
        scheduled_install_day: '5',
        scheduled_install_time: '1',
        use_wuserver: '1',
        reschedule_wait_time: '1',
        no_auto_reboot_with_logged_on_users: '1'
      }
    end

    it { is_expected.to contain_registry_value('NoAutoUpdate').with('data' => '1') }
    it { is_expected.to contain_registry_value('AUOptions').with('data' => '1') }
    it { is_expected.to contain_registry_value('ScheduledInstallDay').with('data' => '5') }
    it { is_expected.to contain_registry_value('ScheduledInstallTime').with('data' => '1') }
    it { is_expected.to contain_registry_value('UseWUServer').with('data' => '1') }
    it { is_expected.to contain_registry_value('RescheduleWaitTime').with('data' => '1') }
    it { is_expected.to contain_registry_value('NoAutoRebootWithLoggedOnUsers').with('data' => '1') }
  end

  invalid_params.each_key do |key, _value|
    context "passing invalid param to #{key}" do
      let :params do
        { key: :value }
      end

      it { is_expected.to raise_error(Puppet::Error) }
    end
  end
end
