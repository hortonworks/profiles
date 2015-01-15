# == Class: profiles::datadog::httpd
#
# Profile class to setup the Datadog integration for Apache httd
# 
# === Dependencies
# This class requires the profile::datadog::agent class.
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc unless otherwise noted.
#
class profiles::datadog::httpd {

  include ::profiles::datadog::agent

  package { 'collectd-apache':
    ensure  => 'latest',
    notify  => Service['httpd'],
    require => Package['httpd']
  }

  file { 'mod_status':
    ensure => 'file',
    path   => '/etc/httpd/conf.d/status.load',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/profiles/status.load',
    require => Package['collectd-apache'],
    notify  => Service['httpd']
  }

  include ::datadog_agent::integrations::apache

}
