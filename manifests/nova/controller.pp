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
  $quota    = hiera('nova::quota')
  $password = $settings[password]

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
    database_connection => "mysql://nova:${password}@127.0.0.1/nova?charset=utf8",
    rabbit_userid       => $settings[rabbit_userid],
    rabbit_password     => $settings[password],
    rabbit_host         => $settings[rabbit_host],
    image_service       => $settings[image_service],
    glance_api_servers  => $settings[glance_api_servers],
    verbose             => $settings[verbose],
  }

  class { '::nova::keystone::auth':
    password => $settings[password],
    region   => $settings[region],
    email    => $settings[email],
  }

  include ::nova::conductor
  include ::nova::consoleauth
  include ::nova::logging
  include ::nova::network::neutron
  include ::nova::scheduler
  include ::nova::scheduler::filter
  include ::nova::utilities
  include ::nova::vncproxy

  class { '::nova::quota':
    quota_instances                       => $quota[quota_instances],
    quota_cores                           => $quota[quota_cores],
    quota_ram                             => $quota[quota_ram],
    quota_volumes                         => $quota[quota_volumes],
    quota_gigabytes                       => $quota[quota_gigabytes],
    quota_floating_ips                    => $quota[quota_floating_ips],
    quota_metadata_items                  => $quota[quota_metadata_items],
    quota_max_injected_files              => $quota[quota_max_injected_files],
    quota_max_injected_file_content_bytes => $quota[quota_max_injected_file_content_bytes],
    quota_max_injected_file_path_bytes    => $quota[quota_max_injected_file_path_bytes],
    quota_key_pairs                       => $quota[quota_key_pairs],
    reservation_expire                    => $quota[reservation_expire],
  }

}
