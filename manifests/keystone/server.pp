# == Class: profiles::keystone::server
#
# Profile class for keystone server setup
#
#  class { 'profiles':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Scott Brimhall <sbrimhall@hortonworks.com>
#
# === Copyright
#
# Copyright 2014 Hortonworks, LLC
#
class profiles::keystone::server {

  # Hiera lookups to grab keystone server settings
  $settings                 = hiera(keystone::settings)
  $keystone_service         = hiera(keystone::service)

  class { '::keystone::db::mysql':
    mysql_module  => $settings[mysql_module],
    password      => $settings[password],
    allowed_hosts => $settings[allowed_hosts],
  }

  class { '::keystone':
    verbose         => $settings[verbose],
    catalog_type    => $settings[catalog_type],
    admin_token     => $settings[admin_token],
    sql_connection  => "mysql://keystone_admin:${settings[password]}@${settings[server]}/keystone",
    rabbit_userid   => $settings[rabbit_user],
    rabbit_password => $settings[password],
  }
  
  class { 'keystone::roles::admin':
    email    => $settings[email],
    password => $settings[password],
  }

  class { '::keystone::endpoint':
    public_address   => $keystone_service[public_address],
    admin_address    => $keystone_service[admin_address],
    internal_address => $keystone_service[internal_address],
    region           => $keystone_service[region],
  }

  rabbitmq_user { $settings[rabbit_user]:
    ensure   => present,
    password => $settings[password],
    admin    => true,
  }

  rabbitmq_vhost { $settings[rabbit_vhost]:
    ensure => present,
  }

}
