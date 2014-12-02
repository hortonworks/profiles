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
  $settings         = hiera('nova::settings')
  $quota            = hiera('nova::quota')
  $neutron          = hiera('neutron::settings')
  $password         = $settings[password]
  $neutron_password = $neutron[password]

  # Make better later.  Make sure RDO repo is installed
  package { 'rdo-release':
    name     => 'rdo-release',
    ensure   => installed,
    provider => rpm,
    source   => 'https://rdo.fedorapeople.org/rdo-release.rpm',
  }
  
  # Setup rabbit user for nova
  rabbitmq_user { 'nova':
    ensure   => present,
    password => $password,
    admin    => true,
  }

  rabbitmq_vhost { $settings[rabbit_vhost]:
    ensure => present,
  }

  # Install nova database
  class { '::nova::db::mysql':
    mysql_module  => '3.0',
    password      => $password,
    allowed_hosts => '%',
  }

  # Install nova
  class { '::nova':
    mysql_module        => '3.0',
    database_connection => "mysql://nova:${password}@127.0.0.1/nova?charset=utf8",
    rabbit_userid       => $settings[rabbit_userid],
    rabbit_password     => $password,
    rabbit_host         => $settings[rabbit_host],
    rabbit_virtual_host => $settings[rabbit_vhost],
    image_service       => $settings[image_service],
    glance_api_servers  => $settings[glance_api_servers],
    verbose             => $settings[verbose],
  }

  class { '::keystone::roles::admin':
    email        => $settings[email],
    password     => $password,
    admin_tenant => $settings[admin_tenant],
  }

  # Nova API
  class { '::nova::api':
    admin_password => $password,
    enabled        => true,
  }

  # Nova Conductor
  class { '::nova::conductor':
    enabled => true,
  }

  # Console auth
  class { '::nova::consoleauth':
    enabled => true,
  }

  # Nova cli utilities
  include ::nova::client

  # Logging
  include ::nova::logging

  # Neutron settings for nova.conf
  class { '::nova::network::neutron':
    neutron_admin_password => $neutron_password,
    neutron_region_name    => $neutron[neutron_region_name],
  }

  # Scheduler and filter
  class { '::nova::scheduler':
    enabled => true,
  }
  
  include ::nova::scheduler::filter

  include ::nova::utilities

  # VNC
  include ::nova::vncproxy

  # Quotas for the cluster
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
