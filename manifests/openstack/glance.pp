# == Class: profiles::openstack::glance
#
# Profile class for setting up Glance
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, Inc.
#
class profiles::openstack::glance {

  # Hiera lookups
  $settings         = hiera('glance::settings')
  $password         = $settings[password]

  # Glance keystone settings
  class { '::glance::keystone::auth':
    password         => $password,
    email            => $settings[email],
    public_address   => $settings[public_address],
    admin_address    => $settings[admin_address],
    internal_address => $settings[internal_address],
    region           => $settings[region],
  }

  # Setup rabbit user for rabbit
  rabbitmq_user { 'glance':
    ensure   => present,
    password => $password,
    admin    => true,
  }

  # Create permissions for rabbit user
  rabbitmq_user_permissions { 'glance@/':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }

  # Setup Glance DB
  class { 'glance::db::mysql':
    mysql_module  => '3.0',
    password      => $password,
    allowed_hosts => ['%', 'localhost'],
  }

  # Setup Glance API
  class { '::glance::api':
    mysql_module      => '3.0',
    verbose           => $settings[verbose],
    keystone_tenant   => $settings[keystone_tenant],
    keystone_user     => $settings[keystone_user],
    keystone_password => $password,
    sql_connection    => "mysql://glance:${password}@127.0.0.1/glance",
  }

  # Glance Registry
  class { '::glance::registry':
    mysql_module      => '3.0'
    verbose           => $settings[verbose],
    keystone_tenant   => $settings[keystone_tenant],
    keystone_user     => $settings[keystone_user],
    keystone_password => $password,
    sql_connection    => "mysql://glance:${password}@127.0.0.1/glance",
  }

  class { '::glance::backend::cinder': }
  
  class { '::glance::notify::rabbitmq':
    rabbit_password => $password,
    rabbit_userid   => $settings[rabbit_userid],
    rabbit_hosts    => [$settings[rabbit_hosts]],
    rabbit_use_ssl  => $settings[rabbit_use_ssl],
  }

}
