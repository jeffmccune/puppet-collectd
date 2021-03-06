require 'spec_helper'

describe 'collectd::plugin::disk', type: :class do
  let :facts do
    {
      osfamily: 'RedHat',
      collectd_version: '4.8.0',
      operatingsystemmajrelease: '7'
    }
  end

  context ':ensure => present and :disks => [\'sda\']' do
    let :params do
      { disks: ['sda'] }
    end
    it 'Will create /etc/collectd.d/10-disk.conf' do
      should contain_file('disk.load').with(ensure: 'present',
                                            path: '/etc/collectd.d/10-disk.conf',
                                            content: %r{Disk  "sda"})
    end
  end

  context ':ensure => absent' do
    let :params do
      { disks: ['sda'], ensure: 'absent' }
    end
    it 'Will not create /etc/collectd.d/10-disk.conf' do
      should contain_file('disk.load').with(ensure: 'absent',
                                            path: '/etc/collectd.d/10-disk.conf')
    end
  end

  context ':manage_package => true on osfamily => RedHat' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5',
        operatingsystemmajrelease: '7'
      }
    end

    let :params do
      {
        manage_package: true
      }
    end
    it 'Will manage collectd-disk' do
      should contain_package('collectd-disk').with(ensure: 'present',
                                                   name: 'collectd-disk')
    end
  end

  context ':manage_package => false on osfamily => RedHat' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5',
        operatingsystemmajrelease: '7'
      }
    end

    let :params do
      {
        manage_package: false
      }
    end
    it 'Will not manage collectd-disk' do
      should_not contain_package('collectd-disk').with(ensure: 'present',
                                                       name: 'collectd-disk')
    end
  end

  context ':manage_package => undef on osfamily => RedHat with collectd 5.5 and up' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5',
        operatingsystemmajrelease: '7'
      }
    end

    it 'Will manage collectd-disk' do
      should contain_package('collectd-disk').with(ensure: 'present',
                                                   name: 'collectd-disk')
    end
  end

  context ':manage_package => undef on osfamily => RedHat with collectd 5.5 and below' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.4',
        operatingsystemmajrelease: '7'
      }
    end

    it 'Will not manage collectd-disk' do
      should_not contain_package('collectd-disk').with(ensure: 'present',
                                                       name: 'collectd-disk')
    end
  end

  context ':disks is not an array' do
    let :params do
      { disks: 'sda' }
    end
    it 'Will raise an error about :disks being a String' do
      should compile.and_raise_error(%r{String})
    end
  end

  context ':udevnameattr on collectd < 5.5' do
    let :params do
      { udevnameattr: 'DM_NAME' }
    end
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.4',
        operatingsystemmajrelease: '7'
      }
    end
    it 'Will not include the setting' do
      should contain_file('disk.load').with(ensure: 'present',
                                            path: '/etc/collectd.d/10-disk.conf').without_content(%r{UdevNameAttr DM_NAME})
    end
  end

  context ':udevnameattr on collectd >= 5.5' do
    let :params do
      { udevnameattr: 'DM_NAME' }
    end
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '5.5',
        operatingsystemmajrelease: '7'
      }
    end
    it 'Will include the setting' do
      should contain_file('disk.load').with(ensure: 'present',
                                            path: '/etc/collectd.d/10-disk.conf',
                                            content: %r{UdevNameAttr DM_NAME})
    end
  end
end
