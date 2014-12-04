# == Class: profiles::openstack::neutron::server
#
# Profile class for setting up Neutron
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc.
#
class profiles::openstack::neutron::server {

  # Hiera lookups
  $settings         = hiera('neutron::settings')
  $password         = $settings[password]

  # Setup rabbit user for Neutron
  rabbitmq_user { 'neutron':
    ensure   => present,
    password => $password,
    admin    => true,
  }

  # Create permissions for rabbit user
  rabbitmq_user_permissions { 'neutron@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  # Install neutron database
  class { '::neutron::db::mysql':
    mysql_module  => '3.0',
    password      => $password,
    allowed_hosts => ['%', 'localhost'],
  }

  # Install Neutron
  class { '::neutron':
    enabled             => true,
    database_connection => "mysql://neutron:${password}@127.0.0.1/neutron?charset=utf8",
    rabbit_user         => $settings[rabbit_userid],
    rabbit_password     => $password,
    rabbit_host         => $settings[rabbit_host],
    rabbit_virtual_host => $settings[rabbit_vhost],
    verbose             => $settings[verbose],
    debug               => $settings[debug],
  }

  class { '::neutron::keystone::auth':
    password => $password,
    region   => $settings[region],
    tenant   => $settings[admin_tenant],
    email    => $settings[email],
  }

  class { '::neutron::server':
    auth_host           => $settings[auth_host],
    auth_password       => $password,
    database_connection => "mysql://neutron:${password}@127.0.0.1/neutron?charset=utf8",
  }

  class { 'neutron::plugins::ovs':
    tenant_network_type => $settings[tenant_network_type],
    network_vlan_ranges => $settings[network_vlan_ranges],
  }

}
