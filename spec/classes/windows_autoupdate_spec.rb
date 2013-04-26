require 'spec_helper'
require 'facets/string/titlecase'

class String
  def titleize
    split(/(\W)/).map(&:capitalize).join
  end
end

$p_reg_key = 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU'

$defaults = { 'noAutoUpdate' => '0', 'aUOptions' => '4', 'scheduledInstallDay' => '1',
              'scheduledInstallTime' => '1', 'useWUServer' => '0', 'rescheduleWaitTime' => '0',
              'noAutoRebootWithLoggedOnUsers' => '0' }

$params = $defaults.keys

describe 'windows_autoupdate', :type => :class do      
  
  let :facts do
    { :operatingsystemversion => 'Windows Server 2008 R2' }
  end

  let :hiera_data do
    { :au_noAutoUpdate => '0', :au_aUOptions => '4', :au_scheduledInstallDay => '1', :au_scheduledInstallTime => '1',
      :au_useWUServer => '0', :au_rescheduleWaitTime => '0', :au_noAutoRebootWithLoggedOnUsers => '0'
    }
  end
 
  context 'basic requirements' do
    let :params do
      { :noAutoUpdate => '0', :aUOptions => '4', :scheduledInstallDay => '1',
        :scheduledInstallTime => '1', :useWUServer => '0', :rescheduleWaitTime => '0',
        :noAutoRebootWithLoggedOnUsers => '0' }
    end
    it { should contain_registry_key($p_reg_key ) }
  
    $params.each do |value|
      it { should contain_registry_value(value.titlecase).with(
        'ensure'  => 'present',
        'path'    => "#{$p_reg_key}\\#{value.titlecase}",
        'type'    => 'dword',
        'data'    => $defaults[value]
      )}
    end
  
    it { should contain_service('wuauserv').with(
      'ensure' => 'running',
      'enable' => 'true'
    )}
  end
  
  $params.each do |value|
    context "passing custom param: #{value}" do
      let :params do
        { value => '1' }
      end
      it { should contain_registry_value(value.titlecase).with(
        'data' => '1'
      )}
    end
    
    context "passing invalid param to: #{value}" do
      let :params do
        { value => '100' }
      end
      it do
        expect {
         should contain_registry_value(value)
        }.to raise_error(Puppet::Error)
      end
    end
  end
  
end