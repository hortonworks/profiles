# == Class: profiles::nova::controller
#
# Profile class for setting up an openstack controller
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc.
#
class profiles::nova::controller {

  # Hiera lookups
  $settings = hiera('nova::settings')

  package { 'rdo-release':
    name     => 'rdo-release',
    ensure   => installed,
    provider => rpm,
    source   => 'https://rdo.fedorapeople.org/rdo-release.rpm',
  }
  
  # Setup rabbit user for nova
  rabbitmq_user { 'nova':
    ensure   => present,
    password => $settings[password],
    admin    => true,
  }

  rabbitmq_vhost { $settings[rabbit_vhost]:
    ensure => present,
  }

  class { '::nova':
    mysql_module        => '3.0',
    database_connection => "mysql://nova:$settings[password]@127.0.0.1/nova?charset=utf8",
    rabbit_userid       => $settings[rabbit_userid],
    rabbit_password     => $settings[password],
    rabbit_host         => $settings[rabbit_host],
    image_service       => $settings[image_service],
    glance_api_servers  => $settings[glance_api_servers],
    verbose             => $settings[verbose],
  }

  include ::nova::conductor
  include ::nova::consoleauth
  include ::nova::keystone::auth
  include ::nova::logging
  include ::nova::manage::floating
  include ::nova::network::neutron
  include ::nova::scheduler
  include ::nova::scheduler::filter
  include ::nova::utilities
  include ::nova::vncproxy

}
