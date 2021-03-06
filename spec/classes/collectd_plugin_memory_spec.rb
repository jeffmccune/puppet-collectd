require 'spec_helper'

describe 'collectd::plugin::memory', type: :class do
  let :facts do
    {
      osfamily: 'RedHat',
      collectd_version: '4.8.0',
      operatingsystemmajrelease: '7'
    }
  end
  context ':ensure => present, default params' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '4.8.0',
        operatingsystemmajrelease: '7'
      }
    end

    it 'Will create /etc/collectd.d/10-memory.conf' do
      should contain_file('memory.load').with(ensure: 'present',
                                              path: '/etc/collectd.d/10-memory.conf',
                                              content: %r{LoadPlugin memory})
    end
  end

  context ':ensure => present, specific params, collectd version 5.4.2' do
    let :facts do
      {
        osfamily: 'Redhat',
        collectd_version: '5.4.2',
        operatingsystemmajrelease: '7'
      }
    end

    it 'Will create /etc/collectd.d/10-memory.conf for collectd < 5.5' do
      should contain_file('memory.load').with(ensure: 'present',
                                              path: '/etc/collectd.d/10-memory.conf',
                                              content: %r{LoadPlugin memory})
    end

    it 'Will not include ValuesPercentage in /etc/collectd.d/10-memory.conf' do
      should_not contain_file('memory.load').with_content(%r{ValuesPercentage})
    end
  end

  context ':ensure => present, specific params, collectd version 5.5.0' do
    let :facts do
      {
        osfamily: 'Redhat',
        collectd_version: '5.5.0',
        operatingsystemmajrelease: '7'
      }
    end

    it 'Will create /etc/collectd.d/10-memory.conf for collectd >= 5.5' do
      should contain_file('memory.load').with(ensure: 'present',
                                              path: '/etc/collectd.d/10-memory.conf',
                                              content: "# Generated by Puppet\n<LoadPlugin memory>\n  Globals false\n</LoadPlugin>\n\n<Plugin memory>\n  ValuesAbsolute true\n  ValuesPercentage false\n</Plugin>\n\n")
    end
  end

  context ':ensure => absent' do
    let :facts do
      {
        osfamily: 'RedHat',
        collectd_version: '4.8.0',
        operatingsystemmajrelease: '7'
      }
    end

    let :params do
      { ensure: 'absent' }
    end

    it 'Will not create /etc/collectd.d/10-memory.conf' do
      should contain_file('memory.load').with(ensure: 'absent',
                                              path: '/etc/collectd.d/10-memory.conf')
    end
  end
end
