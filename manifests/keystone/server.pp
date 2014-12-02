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

  # Hiera lookups to grab keystone server defaults
  $defaults                 = hiera(keystone::defaults)
  $keystone_service         = hiera(keystone::service)
  $keystone_tenant_defaults = hiera(keystone::tenant::defaults)

  class { '::keystone':
    verbose        => $defaults[verbose],
    catalog_type   => $defaults[catalog_type],
    admin_token    => $defaults[admin_token],
    sql_connection => $defaults[sql_connection],
  }
  
  class { '::keystone::db::mysql':
    password      => $defaults[password],
    allowed_hosts => $defaults[allowed_hosts],
  }

  class { 'keystone::roles::admin':
    email    => $defaults[email],
    password => $defaults[password],
  }

  class { '::keystone::endpoint':
    public_address   => $keystone_service[public_address],
    admin_address    => $keystone_service[admin_address],
    internal_address => $keystone_service[internal_address],
    region           => $keystone_service[region],
  }

}
