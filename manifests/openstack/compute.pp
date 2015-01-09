# == Class: profiles::openstack::compute
#
# Profile class for managing an Openstack Compute node
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2015 Hortonworks, Inc., unless otherwise noted.
#
class profiles::openstack::compute {

  # Hiera lookups
  $services = hiera('openstack::compute::services')

  service { $services:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}
