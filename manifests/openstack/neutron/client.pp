# == Class: profiles::openstack::neutron::client
#
# Profile class for setting up Neutron on a compute node
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc.
#
class profiles::openstack::neutron::client {

  # Hiera lookups
  $settings         = hiera('neutron::settings')
  $nova_settings    = hiera('nova::settings')
  $nova_password    = $nova_settings[password]
  $password         = $settings[password]

  # Install Neutron
  class { '::neutron':
    enabled             => true,
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

  include ::neutron::client

}
