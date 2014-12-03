# == Class: profiles::openstack::cinder::controller
#
# Profile class for setting up the cinder service
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc.
#
class profiles::openstack::cinder::controller {

  # Hiera lookups
  $settings         = hiera('cinder::settings')
  $password         = $settings[password]
  $controller_host  = $settings[controller_host]

  # Setup rabbit user for cinder
  rabbitmq_user { 'cinder':
    ensure   => present,
    password => $password,
    admin    => true,
  }

  rabbitmq_user_permissions { 'cinder@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  # Install cinder database
  class { '::cinder::db::mysql':
    mysql_module  => '3.0',
    password      => $password,
    allowed_hosts => ['%', 'localhost'],
  }

  # Install cinder
  class { '::cinder':
    mysql_module        => '3.0',
    database_connection => "mysql://cinder:${password}@127.0.0.1/cinder?charset=utf8",
    rabbit_userid       => $settings[rabbit_userid],
    rabbit_password     => $password,
    rabbit_host         => $settings[rabbit_host],
    rabbit_virtual_host => $settings[rabbit_vhost],
    verbose             => $settings[verbose],
  }

  class { '::cinder::keystone::auth':
    password => $password,
    region   => $settings[region],
    tenant   => $settings[admin_tenant],
    email    => $settings[email],
  }

  # Cinder API
  class { '::cinder::api':
    keystone_password  => $password,
    keystone_enabled   => $settings[keystone_enabled],
    keystone_user      => $settings[keystone_user],
    keystone_auth_host => $settings[keystone_auth_host],
    keystone_auth_port => $settings[keystone_auth_port],
    enabled            => true,
    keystone_tenant    => $settings[admin_tenant],
    bind_host          => $settings[bind_host],
  }

  # Scheduler and filter
  class { '::cinder::scheduler':
    scheduler_driver => $settings[scheduler_driver],
  }

  include ::cinder::volume

  # Setup the local iscsi export from the local volume group
  class { '::cinder::volume::iscsi':
    iscsi_ip_address    => $settings[iscsi_ip_address],
    volume_backend_name => $settings[volume_backend_name],
    iscsi_helper        => $settings[iscsi_helper],
    volume_group        => $settings[volume_group],
  }

}
