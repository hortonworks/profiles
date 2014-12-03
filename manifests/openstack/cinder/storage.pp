# == Class: profiles::openstack::cinder::storage
#
# Profile class for setting up a cinder storage node
# i.e. a compute node to use the Cinder storage service
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc.
#
class profiles::openstack::cinder::storage {

  # Hiera lookups
  $settings         = hiera('cinder::settings')
  $password         = $settings[password]
  $host             = $settings[controller_host]
  $backend_name     = $settings[volume_backend_name]

  # Install cinder
  class { '::cinder':
    mysql_module        => '3.0',
    database_connection => "mysql://cinder:${password}@${host}/cinder?charset=utf8",
    rabbit_userid       => $settings[rabbit_userid],
    rabbit_password     => $password,
    rabbit_host         => $settings[rabbit_host],
    rabbit_virtual_host => $settings[rabbit_vhost],
    verbose             => $settings[verbose],
  }

  # Scheduler and filter
  class { '::cinder::scheduler':
    scheduler_driver => $settings[scheduler_driver],
  }

  # Install the Cinder Volume service
  include ::cinder::volume

  # Setup the local iscsi export from the local volume group
  # This requires there to be a cinder-volumes VG created already
  cinder::backend::iscsi { $backend_name:
    iscsi_ip_address    => $settings[iscsi_ip_address],
    volume_backend_name => $settings[volume_backend_name],
    iscsi_helper        => $settings[iscsi_helper],
    volume_group        => $settings[volume_group],
  }

}
