# == Class: profiles::mysql::server
#
# Profile class for mysql server setup
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
class profiles::mysql::server {

  # Hiera lookups to grab mysql server defaults
  $defaults = hiera(mysql::server::defaults)

  class { '::mysql::server':
    root_password   => $defaults[password],
    service_enabled => $defaults[service_enabled],
    restart         => $defaults[restart],
  }

}
