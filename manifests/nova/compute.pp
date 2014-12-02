# == Class: profiles::nova::compute
#
# Profile class for setting up nova compute
#
# === Variables
#
# The hiera lookups here should have an application_tier (parameter in foreman)
# set to the cluster in question so that the corresponding compute_settings are pulled in
# i.e. engr-us-1 or something like that.  Then a yaml file with all the variables
# talked about here should exist within the hiera datadir defined in hiera.yaml
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc.
#
class profiles::nova::compute {

  # Hiera lookups
  $nova_settings            = hiera('nova::settings')
  $compute_settings = hiera('nova::compute')

  class { '::nova':
    database_connection => "mysql://nova:$nova_settings[password]@127.0.0.1/nova?charset=utf8",
    image_service       => $nova_settings[image_service],
    glance_api_servers  => $nova_settings[glance_api_servers],
    verbose             => $nova_settings[verbose],
  }
  
  class { '::nova::compute':
    enabled            => $compute_settings[enabled],
    vnc_enabled        => $compute_settings[vnc_enabled],
    vncproxy_host      => $compute_settings[vncproxy_host],
    force_config_drive => $compute_settings[force_config_drive],
    virtio_nic         => $compute_settings[virtio_nic],
    neutron_enabled    => $compute_settings[neutron_enabled],
  }

  class { '::nova::compute::libvirt':
    migration_support => true,
  }

  include ::nova::compute::neutron

}
